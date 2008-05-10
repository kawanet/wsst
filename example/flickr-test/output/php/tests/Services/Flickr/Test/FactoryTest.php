<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Test case for the class "Services_Flickr_Test_Factory"
 *
 * PHP versions 5
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
require_once 'PHPUnit/Framework.php';
require_once 'Services/Flickr/Test/Factory.php';
require_once 'Services/Flickr/Test/Request.php';
require_once 'Services/Flickr/Test/Response.php';

/**
 * Test class for Services_Flickr_Test_Factory
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_FactoryTest extends PHPUnit_Framework_TestCase
{
    protected $object;
    
    public function setUp()
    {
        $this->object = new Services_Flickr_Test_Factory();
    }
    
    public function testCreateRequest()
    {
        $req =& $this->object->createRequest();
        $this->assertFalse(PEAR::isError($req), 'PEAR::isError');
        $this->assertTrue(($req instanceof Services_Flickr_Test_Request), 'instanceof');
    }
    
    public function testCreateResponse()
    {
        $res =& $this->object->createResponse();
        $this->assertFalse(PEAR::isError($res), 'PEAR::isError');
        $this->assertTrue(($res instanceof Services_Flickr_Test_Response), 'instanceof');
    }
}

?>
