<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Test case for the class "Services_Flickr_Test_Response_Default"
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
require_once 'Services/Flickr/Test/Response.php';
require_once 'Services/Flickr/Test/Response/Default.php';
require_once 'Services/Flickr/Test/Factory.php';

/**
 * Test class for Services_Flickr_Test_Response_Default
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Response_DefaultTest extends PHPUnit_Framework_TestCase
{
    public static function provideXml()
    {
        $xml = <<<XML
<test>
  <elm1>text1</elm1>
  <elm2>text2</elm2>
  <elm3>
    <elm3_1>text3_1</elm3_1>
    <elm3_2>text3_2</elm3_2>
  </elm3>
  <elm4 attr1='a1' attr2='a2' />
</test>
XML;

        $res = new stdClass();
        $res->elm1 = 'text1';
        $res->elm2 = 'text2';
        $res->elm3 = new stdClass();
        $res->elm3->elm3_1 = 'text3_1';
        $res->elm3->elm3_2 = 'text3_2';
        $res->elm4 = new stdClass();
        $res->elm4->attr1 = 'a1';
        $res->elm4->attr2 = 'a2';

        return array(
            array($xml, $res)
        );
    }

    public function testDefaultNew()
    {
        $obj = new Services_Flickr_Test_Response_Default();
        $this->assertNotNull($obj);
    }
    
    /**
     * @dataProvider provideXml
     */
    public function testParamedNew($xml, $res)
    {
        $status = "HTTP/1.1 200 OK";
        $headers = array(
            'Content-Type' => 'text/xml',
            'Connection' => 'close',
        );
        
        $obj = new Services_Flickr_Test_Response_Default($status, $headers, $xml);
        
        $this->assertNotNull($obj);
        $this->assertEquals($res, $obj->getData());
        $this->assertEquals($status, $obj->getStatus());
        $this->assertEquals($headers, $obj->getHeaders());
    }
}

?>
