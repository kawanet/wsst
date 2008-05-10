<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file contains the class "Services_Flickr_Test_Method_Echo"
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

require_once 'Services/Flickr/Test/Method.php';

/**
 * Implementation of Method class for accessing "echo"
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Method_Echo extends Services_Flickr_Test_Method
{
    /**
     * Returns the URL
     * 
     * @return string URL
     */
    function getUrl()
    {
        return 'http://api.flickr.com/services/rest/';
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
        return array(
            'fixed' => array(
                'method' => 'flickr.test.echo',
            ),
            'keys' => array(
                'api_key',
            ),
            'notnull' => array(
                'api_key',
                'method',
            ),
        );
    }
    
    /**
     * Returns the conf of respoonse
     * 
     * @access public
     * @return array conf
     */
    function getResponseConf()
    {
        return array(
        );
    }
}

?>
