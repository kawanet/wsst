<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Test case for the class "Services_Flickr_Test"
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
require_once 'Services/Flickr/Test.php';

/**
 * Test class for Services_Flickr_Test
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_TestTest extends PHPUnit_Framework_TestCase
{
    public function testDefaultNew()
    {
        $obj = new Services_Flickr_Test();
        $this->assertNotNull($obj);
        $this->assertTrue(($obj->getFactory() instanceof Services_Flickr_Test_Factory), 'factory');
        $this->assertEquals(array(), $obj->getCommonParams(), 'common_params');
    }
    
    public function testPramedNew()
    {
        $params = array(
            'key' => 'XXXXXXXX',
        );
        $obj = new Services_Flickr_Test($params);
        $this->assertNotNull($obj);
        $this->assertTrue(($obj->getFactory() instanceof Services_Flickr_Test_Factory), 'factory');
        $this->assertEquals($params, $obj->getCommonParams(), 'common_params');
        
        $fac = new Services_Flickr_TestTest_MyFactory();
        $obj = new Services_Flickr_Test($params, $fac);
        $this->assertNotNull($obj);
        $this->assertTrue(($obj->getFactory() instanceof Services_Flickr_Test_Factory), 'factory2');
        $this->assertSame($fac, $obj->getFactory(), 'factory2_same');
        $this->assertEquals($params, $obj->getCommonParams(), 'common_params2');
    }
    
    public function testGetSetFactory()
    {
        $obj = new Services_Flickr_Test();
        $fac = new Services_Flickr_TestTest_MyFactory();
        $this->assertNotSame($fac, $obj->getFactory(), 'factory_notsame');
        $obj->setFactory($fac);
        $this->assertSame($fac, $obj->getFactory(), 'factory_same');
    }
    
    public function testGetSetAddCommonParams()
    {
        $obj = new Services_Flickr_Test(array('val1'=>1));
        $this->assertEquals(array('val1'=>1), $obj->getCommonParams());
        
        $obj->addCommonParams(array('val2'=>2));
        $this->assertEquals(array('val1'=>1,'val2'=>2), $obj->getCommonParams());
        
        $obj->setCommonParams(array('val3'=>3));
        $this->assertEquals(array('val3'=>3), $obj->getCommonParams());
        
        $obj->addCommonParams(array('val3'=>30,'val4'=>40));
        $this->assertEquals(array('val3'=>30,'val4'=>40), $obj->getCommonParams());
    }
    
    function testEcho()
    {
        $obj = new Services_Flickr_Test();

        // Test[0]
        $params = array(
            'api_key' => getenv('FLICKR_API_KEY'),
        );
        $res =& $obj->echo($params);
        $this->assertFalse(PEAR::isError($res), 'Test[0]: isError');
        $data = $res->getData();
        $this->assertNotNull($data, 'Test[0]: getData');
        $this->assertObjectHasAttribute('stat', $data, 'Test[0]: stat');
        $this->assertObjectHasAttribute('method', $data, 'Test[0]: method');
        $this->assertObjectHasAttribute('api_key', $data, 'Test[0]: api_key');

        // Test[1]
        $params = array(
            'api_key' => 'invalid_api_key',
        );
        $res =& $obj->echo($params);
        $this->assertFalse(PEAR::isError($res), 'Test[1]: isError');
        $data = $res->getData();
        $this->assertNotNull($data, 'Test[1]: getData');
        $this->assertObjectHasAttribute('stat', $data, 'Test[1]: stat');
        $this->assertObjectHasAttribute('err', $data, 'Test[1]: err');
        $this->assertObjectHasAttribute('code', $data->err, 'Test[1]: code');
        $this->assertObjectHasAttribute('msg', $data->err, 'Test[1]: msg');

    }

    function testLogin()
    {
        $obj = new Services_Flickr_Test();

        // Test[0]
        $params = array(
            'api_key' => getenv('FLICKR_API_KEY'),
            'api_sig' => getenv('FLICKR_API_SIG'),
            'auth_token' => getenv('FLICKR_AUTH_TOKEN'),
        );
        $res =& $obj->login($params);
        $this->assertFalse(PEAR::isError($res), 'Test[0]: isError');
        $data = $res->getData();
        $this->assertNotNull($data, 'Test[0]: getData');
        $this->assertObjectHasAttribute('stat', $data, 'Test[0]: stat');
        $this->assertObjectHasAttribute('user', $data, 'Test[0]: user');
        $this->assertObjectHasAttribute('id', $data->user, 'Test[0]: id');
        $this->assertObjectHasAttribute('username', $data->user, 'Test[0]: username');

        // Test[1]
        $params = array(
            'api_key' => 'invalid_api_key',
            'api_sig' => 'invalid_api_sig',
            'auth_token' => 'invalid_auth_token',
        );
        $res =& $obj->login($params);
        $this->assertFalse(PEAR::isError($res), 'Test[1]: isError');
        $data = $res->getData();
        $this->assertNotNull($data, 'Test[1]: getData');
        $this->assertObjectHasAttribute('stat', $data, 'Test[1]: stat');
        $this->assertObjectHasAttribute('err', $data, 'Test[1]: err');
        $this->assertObjectHasAttribute('code', $data->err, 'Test[1]: code');
        $this->assertObjectHasAttribute('msg', $data->err, 'Test[1]: msg');

    }


}

class Services_Flickr_TestTest_MyFactory extends Services_Flickr_Test_Factory
{
}
 
?>
