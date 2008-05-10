<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file contains the class "Services_Flickr_Test_Request_Default"
 *
 * PHP versions 4 and 5
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */

require_once 'PEAR.php';

require_once 'Services/Flickr/Test/Request.php';
require_once 'Services/Flickr/Test/Factory.php';

/**
 * Default implementation of Request class
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Request_Default extends Services_Flickr_Test_Request
{
    /**
     * port number
     *
     * @access public
     * @var int
     */
    var $port = 80;
    
    /**
     * timeout seconds
     * if 0 then never set timeout
     *
     * @access public
     * @var int
     */
    var $timeout = 0;

    /**
     * Send
     *
     * @return mixed Services_Flickr_Test_Response|PEAR_Error
     */
    function &send()
    {
        $url = $this->getUrl();
        $purl = parse_url($url);
        if ($purl == false || empty($purl['host'])) {
            return PEAR::raiseError('Invalid URL.');
        }
        
        if (!array_key_exists('port', $purl)) {
            $purl['port'] = null;
        }
        
        $reqStr = $this->_createReqStr($purl);
        
        $host = $purl['host'];
        $port = $purl['port'] ? $purl['port'] : $this->port;
        
        if ($this->timeout) {
            $fp = fsockopen($host, $port, $errno, $errstr, $this->timeout);
        } else {
            $fp = fsockopen($host, $port, $errno, $errstr);
        }
        if (!$fp) {
            return PEAR::raiseError("failed fsockopen(): errno=$errno, errstr=$errstr");
        }

        if ($this->timeout) {
            socket_set_timeout($fp, $this->timeout);
        }
        
        if (fwrite($fp, $reqStr) == false) {
            fclose($fp);
            return PEAR::raiseError('failed fwrite().');
        }

        $status = null;
        $statusCode = null;
        if (!feof($fp)) {
            $status = trim(fgets($fp, 4096));
            sscanf($status, "HTTP/1.%d %d %s", $minor, $statusCode, $statusstr);
        }
        if (!$statusCode || ($statusCode < 200 || 300 <= $statusCode)) {
            $content = '';
            while (!feof($fp)) {
                $content .= fread($fp, 8192);
            }
            fclose($fp);
            return PEAR::raiseError("HTTP Error: status=$status, content=$content");
        }
        
        $headers = array();
        while (!feof($fp)) {
            $line = trim(fgets($fp, 4096));
            if (empty($line)) {
                break;
            }
            list($key, $val) = explode(":", $line);
            $headers[trim($key)] = trim($val);
        }

        $content = '';
        while (!feof($fp)) {
            $content .= fread($fp, 8192);
        }
        
        fclose($fp);

        if ($headers['Transfer-Encoding'] == 'chunked') {
            $content = $this->_decodeChunked($content);
        }
        
        return $this->fac->createResponse($status, $headers, $content);
    }
    
    /**
     * Create request string and return
     * 
     * @access private
     * @param array $purl parsed URL
     * @return string request string
     */
    function _createReqStr($purl)
    {
        $rm = $this->getRequestMethod();
        $params = $this->getParams();

        $reqStr = '';
        
        if (!array_key_exists('query', $purl)) {
            $purl['query'] = null;
        }
        
        if ($rm == 'POST') {
            $query = $purl['path'];
            if ($purl['query']) {
                $query .= '?' . $purl['query'];
            }
            $qstrs = array();
            if ($purl['query']) {
                $qstrs[] = $purl['query'];
            }
            foreach ($params as $key => $val) {
                if (is_array($val)) {
                    foreach ($val as $val2) {
                        $qstrs[] = urlencode($key) . "=" . urlencode($val2);
                    }
                } else {
                    $qstrs[] = urlencode($key) . "=" . urlencode($val);
                }
            }

            $reqStr .= sprintf("%s %s HTTP/1.1\r\n", $rm, $query);
            $reqStr .= "Host: $purl[host]\r\n";
            $reqStr .= "Connection: close\r\n";
            $reqStr .= "Content-Type: application/x-www-form-urlencoded\r\n";
            $reqStr .= "\r\n";
            if ($qstrs) {
                $reqStr .= implode('&', $qstrs) . "\r\n";
            }
            $reqStr .= "\r\n";
        } else {
            $query = $purl['path'];
            //$qstr = http_build_query($params);
            $qstrs = array();
            if ($purl['query']) {
                $qstrs[] = $purl['query'];
            }
            foreach ($params as $key => $val) {
                if (is_array($val)) {
                    foreach ($val as $val2) {
                        $qstrs[] = urlencode($key) . "=" . urlencode($val2);
                    }
                } else {
                    $qstrs[] = urlencode($key) . "=" . urlencode($val);
                }
            }
            if ($qstrs) {
                $query .= '?' . implode('&', $qstrs);
            }

            $reqStr .= sprintf("%s %s HTTP/1.1\r\n", $rm, $query);
            $reqStr .= "Host: $purl[host]\r\n";
            $reqStr .= "Connection: close\r\n";
            $reqStr .= "\r\n";
        } 
        
        return $reqStr;
    }

    /**
     * Decodes chunked content.
     * 
     * @param string $src chunked content
     * @return string decoded content
     */
    function _decodeChunked($src)
    {
        $result = "";
        
        while (strlen($src) > 0) {
            $pos = strpos($src, "\n");
            if ($pos === false) {
                break;
            }
            
            $chunk = substr($src, 0, $pos + 1);
            $chunk_len = strlen($chunk);
            list($len) = sscanf($chunk, "%x");
            if ($len == 0) {
                break;
            }
            
            $result .= substr($src, $chunk_len, $len);
            
            $pos = strpos($src, "\n", $chunk_len + $len);
            if ($pos === false) {
                $pos = $chunk_len + $len;
            }
            $src = substr($src, $pos + 1);
        }
        
        return $result;
    }
}

?>
