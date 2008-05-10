<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Test case for the class "Services_Flickr_Test_Request_Default"
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
require_once 'Services/Flickr/Test/Request/Default.php';

/**
 * Test class for Services_Flickr_Test_Request_Default
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Request_DefaultTest extends PHPUnit_Framework_TestCase
{
    protected $factory;
    
    public function setUp()
    {
        $this->factory = new Services_Flickr_Test_Factory();
    }

    public function testNew()
    {
        $obj = new Services_Flickr_Test_Request_Default($this->factory);
        $this->assertNotNull($obj);
    }

    public function testSend()
    {
        $obj = new Services_Flickr_Test_Request_Default($this->factory);

        $res =& $obj->send();
        $this->assertTrue(PEAR::isError($res));

        $obj->setUrl('http://localhost/test');

        $res =& $obj->send();
        $this->assertFalse(PEAR::isError($res));
        $this->assertTrue(($res instanceof Services_Flickr_Test_Response));
    }
    
    public static function provideCreateReqStr()
    {
        return array(
            array(
                'http://localhost/test',
                null,
                null,
                "GET /test HTTP/1.1\r\n" .
                "Host: localhost\r\n" .
                "Connection: close\r\n" .
                "\r\n"
            ),
            array(
                'http://localhost/test2',
                'GET',
                array(
                    'val1' => 'test1',
                    'val2' => 10,
                    'val3' => array(1, 2, 3),
                ),
                "GET /test2?val1=test1&val2=10&val3=1&val3=2&val3=3 HTTP/1.1\r\n" .
                "Host: localhost\r\n" .
                "Connection: close\r\n" .
                "\r\n"
            ),
            array(
                'http://localhost/test3',
                'POST',
                array(
                    'val1' => 'test1',
                    'val2' => 10,
                    'val3' => array(1, 2, 3),
                ),
                "POST /test3 HTTP/1.1\r\n" .
                "Host: localhost\r\n" .
                "Connection: close\r\n" .
                "Content-Type: application/x-www-form-urlencoded\r\n" .
                "\r\n" .
                "val1=test1&val2=10&val3=1&val3=2&val3=3\r\n" .
                "\r\n"
            ),
        );
    }
    
    /**
     * @dataProvider provideCreateReqStr
     */
    public function testCreateReqStr($url, $rm, $params, $reqStr)
    {
        $obj = new Services_Flickr_Test_Request_Default($this->factory);

        $purl = parse_url($url);
        if ($rm) {
            $obj->setRequestMethod($rm);
        }
        if ($params) {
            $obj->setParams($params);
        }
        $this->assertEquals($reqStr, $obj->_createReqStr($purl));
    }
    
    public static function provideDecodeChunked()
    {
        return array(
            array(
                "1a; parameter\r\n" .
                "abcdefghijklmnopqrstuvwxyz\r\n" .
                "a\r\n" .
                "1234567890\r\n" .
                "0\r\n" .
                "footer1: some-value\r\n" .
                "footer2: another-value\r\n" .
                "\r\n",
                "abcdefghijklmnopqrstuvwxyz1234567890",
            ),
        );
    }

    /**
     * @dataProvider provideDecodeChunked
     */
    public function testDecodeChunked($chunked, $expected)
    {
        $obj = new Services_Flickr_Test_Request_Default($this->factory);
        $this->assertEquals($expected, $obj->_decodeChunked($chunked));
    }
}

?>
