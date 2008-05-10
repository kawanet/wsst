<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file contains the class "Services_Flickr_Test_Request"
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

require_once 'Services/Flickr/Test/Factory.php';
require_once 'Services/Flickr/Test/Response.php';

/**
 * Class encapsulating the HTTP Request
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Request
{
    /**
     * Factory object
     *
     * @access protected
     * @var object
     */
    var $fac;
    
    /**
     * Destination URL
     *
     * @access private
     * @var string
     */
    var $_url = null;
    
    /**
     * Parameters to send
     *
     * @access private
     * @var array
     */
    var $_params = array();
    
    /**
     * Request method
     *
     * @access private
     * @var string
     */
    var $_requestMethod = 'GET';

    /**
     * Constructor
     *
     * @access public
     * @param object $fac Factory object
     */
    function Services_Flickr_Test_Request(&$fac)
    {
        $this->fac =& $fac;
    }
    
    /**
     * Get URL
     *
     * @access public
     * @return string URL
     */
    function getUrl()
    {
        return $this->_url;
    }
    
    /**
     * Set URL
     *
     * @access public
     * @param string $url URL
     * @return void 
     */
    function setUrl($url)
    {
        $this->_url = $url;
    }
    
    /**
     * Get parameters
     *
     * @access public
     * @return array parameters
     */
    function getParams()
    {
        return $this->_params;
    }
    
    /**
     * Set parameters
     *
     * @access public
     * @param array $params parameters
     * @return void
     */
    function setParams($params)
    {
        $this->_params = $params;
    }
    
    /**
     * Add parameters
     * 
     * @access public
     * @param array $params parameters
     * @return void
     */
    function addParams($params)
    {
        $this->_params = array_merge($this->_params, $params);
    }
    
    /**
     * Get request method
     *
     * @access public
     * @return string request method
     */
    function getRequestMethod()
    {
        return $this->_requestMethod;
    }
    
    /**
     * Set request method
     *
     * @access public
     * @param string $requestMethod request method
     * @return void
     */
    function setRequestMethod($requestMethod)
    {
        $this->_requestMethod = strtoupper($requestMethod);
    }
    
    /**
     * Send Request to destination URL
     *
     * @access public
     * @return mixed Services_Flickr_Test_Response|PEAR_Error
     */
    function &send()
    {
        if (is_null($this->_url)) {
            return PEAR::raiseError('URL has not been set.');
        }

        return PEAR::raiseError('Not implemented.');
    }
}

?>
