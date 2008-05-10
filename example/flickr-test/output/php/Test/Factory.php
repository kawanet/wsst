<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file contains the class "Services_Flickr_Test_Factory"
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
require_once 'Services/Flickr/Test/Response.php';

/**
 * Factory class for Request/Response object.
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Factory
{
    /**
     * Create Request object and return
     * 
     * @return object Services_Flickr_Test_Request
     */
    function &createRequest()
    {
        require_once 'Services/Flickr/Test/Request/Default.php';
        $obj =& new Services_Flickr_Test_Request_Default($this);
        return $obj;
    }
    
    /**
     * Create Response object and return
     * 
     * @param string $status HTTP status line 
     * @param string $header HTTP header
     * @param string $content response message content
     * @return object Services_Flickr_Test_Response
     */
    function &createResponse($status = null, $header = null, $content = null)
    {
        require_once 'Services/Flickr/Test/Response/Default.php';
        $obj =& new Services_Flickr_Test_Response_Default($status, $header, $content);
        return $obj;
    }
}

?>
