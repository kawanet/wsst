<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file contains the class "Services_Flickr_Test"
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
require_once 'Services/Flickr/Test/Request.php';
require_once 'Services/Flickr/Test/Response.php';

/**
 * User interface class for accessing Web Service "Flickr Services: Test API Methods"
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test
{
    /**
     * Factory object
     * 
     * @access private
     * @var object
     */
    var $_fac = null;

    /**
     * Common parameters
     * 
     * @access private
     * @var array
     */
    var $_params;

    /**
     * Constructor
     *
     * @access public
     * @param array $params common parameters
     * @param object $fac Factory object
     */
    function Services_Flickr_Test($params = array(), $fac = null)
    {
        if (is_null($fac)) {
            $fac =& new Services_Flickr_Test_Factory();
        }
        $this->_fac =& $fac;
        $this->_params = $params;
    }
    
    /**
     * Get factory object
     * 
     * @access public
     * @return object Factory object
     */
    function &getFactory()
    {
        return $this->_fac;
    }

    /**
     * Set factory object
     * 
     * @access public
     * @param object $fac Factory object
     * @return void
     */
    function setFactory(&$fac)
    {
        $this->_fac =& $fac;
    }
    
    /**
     * Get common parameters
     * 
     * @access public
     * @return array common parameters
     */
    function getCommonParams()
    {
        return $this->_params;
    }
    
    /**
     * Set common parameters
     * 
     * @access public
     * @param array $params common parameters
     * @return void
     */
    function setCommonParams($params)
    {
        $this->_params = $params;
    }
    
    /**
     * Add common parameters
     * 
     * @access public
     * @param array $params common parameters
     * @return void
     */
    function addCommonParams($params)
    {
        $this->_params = array_merge($this->_params, $params);
    }

    /**
     * Makes a request for echo API.
     * See Services_Flickr_Test_Echo for details.
     *
     * @access public
     * @param array $params parameters
     * @return mixed Services_Flickr_Test_Response|PEAR_Error
     * @see Services_Flickr_Test_Echo
     */
    function &echo($params = array())
    {
        require_once 'Services/Flickr/Test/Method/Echo.php';
        $method =& new Services_Flickr_Test_Method_Echo($this->_fac);
        return $method->execute(array_merge($this->_params, $params));
    }

    /**
     * Makes a request for login API.
     * See Services_Flickr_Test_Login for details.
     *
     * @access public
     * @param array $params parameters
     * @return mixed Services_Flickr_Test_Response|PEAR_Error
     * @see Services_Flickr_Test_Login
     */
    function &login($params = array())
    {
        require_once 'Services/Flickr/Test/Method/Login.php';
        $method =& new Services_Flickr_Test_Method_Login($this->_fac);
        return $method->execute(array_merge($this->_params, $params));
    }


}

?>
