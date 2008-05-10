<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Test case for the class "Services_Flickr_Test_Method_Echo"
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
require_once 'Services/Flickr/Test/Method/Echo.php';
require_once 'Services/Flickr/Test/Factory.php';

/**
 * Test class for Services_Flickr_Test_Method_Echo
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Method_EchoTest extends PHPUnit_Framework_TestCase
{
    protected $factory;
	
    public function setUp()
    {
        $this->factory = new Services_Flickr_Test_Factory();
    }
	
    public function testNew()
    {
        $obj = new Services_Flickr_Test_Method_Echo($this->factory);
        $this->assertNotNull($obj);
    }
    
    public function testGetUrl()
    {
        $obj = new Services_Flickr_Test_Method_Echo($this->factory);
        $this->assertEquals('http://api.flickr.com/services/rest/', $obj->getUrl());
    }
    
    public function testGetParamsConf()
    {
    	$obj = new Services_Flickr_Test_Method_Echo($this->factory);
    	$conf = $obj->getParamsConf();
    	$this->assertType('array', $conf);
    	if ($conf['defaults']) {
    	    $this->assertType('array', $conf['defaults']);
    	    $this->assertNull($conf['defaults'][0]);
    	}
    	if ($conf['fixed']) {
    	    $this->assertType('array', $conf['fixed']);
    	    $this->assertNull($conf['fixed'][0]);
    	}
    	if ($conf['keys']) {
    	    $this->assertType('array', $conf['keys']);
    	    $this->assertNotNull($conf['keys'][0]);
    	}
    	if ($conf['notnull']) {
    	    $this->assertType('array', $conf['notnull']);
    	    $this->assertNotNull($conf['notnull'][0]);
    	}
    }
    
    public function testGetResponseConf()
    {
        $obj = new Services_Flickr_Test_Method_Echo($this->factory);
        $conf = $obj->getResponseConf();
        $this->assertType('array', $conf);
        if ($conf['force_array']) {
            $this->assertType('array', $conf['force_array']);
            $this->assertNotNull($conf['force_array'][0]);
        }
    }
    
    public function testExecute()
    {
        $obj = new Services_Flickr_Test_Method_Echo($this->factory);

        // Test[0]
        $params = array(
            'api_key' => getenv('FLICKR_API_KEY'),
        );
        $res =& $obj->execute($params);
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
        $res =& $obj->execute($params);
        $this->assertFalse(PEAR::isError($res), 'Test[1]: isError');
        $data = $res->getData();
        $this->assertNotNull($data, 'Test[1]: getData');
        $this->assertObjectHasAttribute('stat', $data, 'Test[1]: stat');
        $this->assertObjectHasAttribute('err', $data, 'Test[1]: err');
        $this->assertObjectHasAttribute('code', $data->err, 'Test[1]: code');
        $this->assertObjectHasAttribute('msg', $data->err, 'Test[1]: msg');

    }
}

?>
