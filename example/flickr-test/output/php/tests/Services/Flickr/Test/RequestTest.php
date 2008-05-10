<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Test case for the class "Services_Flickr_Test_Request"
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

/**
 * Test class for Services_Flickr_Test_Request
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_RequestTest extends PHPUnit_Framework_TestCase
{
    protected $factory;

    public function setUp()
    {
        $this->factory = new Services_Flickr_Test_Factory();
    }

    public function testNew()
    {
        $obj =& $this->factory->createRequest();
        $this->assertNotNull($obj);
    }

    public function testGetSetUrl()
    {
        $obj =& $this->factory->createRequest();
        $this->assertNull($obj->getUrl());
        $obj->setUrl('http://localhost/test');
        $this->assertEquals('http://localhost/test', $obj->getUrl());
    }

    public function testGetSetAddParams()
    {
        $obj =& $this->factory->createRequest();

        $this->assertEquals(array(), $obj->getParams());

        $obj->setParams(array('val1'=>1, 'val2'=>2));
        $this->assertEquals(array('val1'=>1, 'val2'=>2), $obj->getParams());

        $obj->addParams(array('val2'=>20, 'val3'=>30));
        $this->assertEquals(array('val1'=>1, 'val2'=>20, 'val3'=>30), $obj->getParams());
    }

    public function testGetSetRequestMethod()
    {
        $obj =& $this->factory->createRequest();
        $this->assertEquals('GET', $obj->getRequestMethod());
        $obj->setRequestMethod('POST');
        $this->assertEquals('POST', $obj->getRequestMethod());
    }

    public function testSend()
    {
        $obj =& $this->factory->createRequest();

        $res =& $obj->send();
        $this->assertTrue(PEAR::isError($res));

        $obj->setUrl('http://localhost/test');

        $res =& $obj->send();
        $this->assertFalse(PEAR::isError($res));
        $this->assertTrue(($res instanceof Services_Flickr_Test_Response));
    }
}

?>
