<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file contains the class "Services_Flickr_Test_Method"
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
 * Base class for method
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Method
{
    /**
     * Factory object
     * 
     * @access protected
     * @var object
     */
    var $fac;

    /**
     * Constructor
     * 
     * @param object $fac Factory object
     */
    function Services_Flickr_Test_Method(&$fac)
    {
        $this->fac =& $fac;
    }

    /**
     * Returns the URL (must override in subclass)
     * 
     * @access public
     * @return string URL
     */
    function getUrl()
    {
        return null;
    }

    /**
     * Returns request method
     * 
     * @access public
     * @return string request method
     */
    function getRequestMethod()
    {
        return 'GET';
    }

    /**
     * Returns the conf of parameters
     * 
     * @access public
     * @return array conf
     */
    function getParamsConf()
    {
        return array();
    }
    
    /**
     * Return the conf of respoonse
     * 
     * @access public
     * @return array conf
     */
    function getResponseConf()
    {
        return array();
    }
    
    /**
     * Filter parameters
     * 
     * @access public
     * @param array $params parameters
     * @return array result
     */
    function filterParams($params)
    {
        $conf = $this->getParamsConf();
        if (!$conf) {
            return $params;
        }
    
        $result = array();
        
        if (array_key_exists('keys', $conf) && $conf['keys']) {
            foreach ($conf['keys'] as $key) {
                if (array_key_exists($key, $params)) {
                    $result[$key] = $params[$key];
                }
            }
        } else {
            $result = $params;
        }
        
        if (array_key_exists('defaults', $conf) && $conf['defaults']) {
            foreach ($conf['defaults'] as $key => $val) {
                if (!array_key_exists($key, $params)) {
                    $result[$key] = $val;
                }
            }
        }
        
        if (array_key_exists('fixed', $conf) && $conf['fixed']) {
            foreach ($conf['fixed'] as $key => $val) {
                $result[$key] = $val;
            }
        }
        
        return $result;
    }
    
    /**
     * Filter response
     * 
     * @access public
     * @param object $res response
     * @return object result
     */
    function &filterResponse(&$res)
    {
        $res->processData($this->getResponseConf());
        return $res;
    }
    
    /**
     * Validate parameters
     * 
     * @access public
     * @param array $params parameters
     * @return array result or false
     */
    function validateParams($params)
    {
        $conf = $this->getParamsConf();
        if (!$conf && $conf['notnull']) {
            return false;
        }
    
        $result = array();

        $notnull = array();
        foreach ($conf['notnull'] as $key) {
            if (!$params[$key]) {
                $notnull[] = $key;
            }
        }
        if ($notnull) {
            $result[] = "empty parameters - " . implode(' ', $notnull);
        }
        
        return $result;
    }
    
    /**
     * Execute the method
     *
     * @access public
     * @param array $params parameters
     * @return object Services_Flickr_Test_Response
     */
    function &execute($params)
    {
        $params = $this->filterParams($params);
    
        if ($validate = $this->validateParams($params)) {
            return PEAR::raiseError('ValidateError: ' . print_r($validate, true));
        }
        
        $req =& $this->fac->createRequest();
        
        $req->setUrl($this->getUrl());
        $req->setRequestMethod($this->getRequestMethod());
        $req->addParams($params);
        
        $res =& $req->send();
        
        if (PEAR::isError($res)) {
            return $res;
        }
        
        $res =& $this->filterResponse($res);
        
        return $res;
    }
}

?>
