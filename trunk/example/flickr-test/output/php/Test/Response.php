<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file contains the class "Services_Flickr_Test_Response"
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

/**
 * Class encapsulating the HTTP Response
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Response
{
    /**
     * HTTP status line
     * 
     * @access private
     * @var string
     */
    var $_status = null;
    
    /**
     * HTTP response header
     * 
     * @access private
     * @var array
     */
    var $_header = null;

    /**
     * HTTP response message content
     * 
     * @access private
     * @var string
     */
    var $_content = null;
    
    /**
     * parsed response XML data
     * 
     * @access private
     * @var array
     */
    var $_data = null;
    
    /**
     * Error message of processData()
     *
     * If processData method has error,
     * the message is set.
     *
     * @access protected
     * @var string
     */
    var $processDataError = null;

    /**
     * Constructor
     * 
     * @access public
     * @param string $status HTTP status line
     * @param string $headers HTTP response header
     * @param string $content HTTP response message content
     */
    function Services_Flickr_Test_Response($status = null, $headers = null, $content = null)
    {
        if (!is_null($status)) {
            $this->setStatus($status);
        }
        if (!is_null($headers)) {
            $this->setHeaders($headers);
        }
        if (!is_null($content)) {
            $this->setContent($content);
        }
    }
    
    /**
     * Get status
     * 
     * @access public
     * @return string status line
     */
    function getStatus()
    {
        return $this->_status;
    }
    
    /**
     * Set status
     * 
     * @access public
     * @param string $status status line
     * @return void
     */
    function setStatus($status)
    {
        $this->_status = $status;
    }
    
    /**
     * Get headers
     * 
     * @access public
     * @return array headers
     */
    function getHeaders()
    {
        return $this->_headers;
    }
    
    /**
     * Set headers
     * 
     * @access public
     * @param array $headers headers
     * @return void
     */
    function setHeaders($headers)
    {
        $this->_headers = $headers;
    }
    
    /**
     * Get content
     * 
     * @access public
     * @return string content
     */
    function getContent()
    {
        return $this->_content;
    }
    
    /**
     * Set content
     * 
     * @access public
     * @param string $content content
     * @return void
     */
    function setContent($content)
    {
        $this->_content = $content;
    }
    
    /**
     * Get data
     * 
     * @access public
     * @return object data
     */
    function &getData()
    {
        if (!$this->_data) {
            $this->processData();
        }
        return $this->_data;
    }

    /**
     * process response XML data
     * 
     * @access public
     * @param array $conf conf
     * @return void
     */
    function processData($conf = array())
    {
    }
    
    /**
     * Returns error message of processData()
     *
     * @access public
     * @return string error message
     */
    function getProcessDataError()
    {
        return $this->processDataError;
    }
}

?>
