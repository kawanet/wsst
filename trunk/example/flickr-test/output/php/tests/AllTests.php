<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * AllTests for Services_Flickr_Test
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

if (!defined('PHPUnit_MAIN_METHOD')) {
    define('PHPUnit_MAIN_METHOD', 'Services_Flickr_Test_AllTests::main');
}

require_once 'PHPUnit/Framework.php';
require_once 'PHPUnit/TextUI/TestRunner.php';

require_once 'Services/Flickr/TestTest.php';
require_once 'Services/Flickr/Test/FactoryTest.php';
require_once 'Services/Flickr/Test/RequestTest.php';
require_once 'Services/Flickr/Test/Request/DefaultTest.php';
require_once 'Services/Flickr/Test/ResponseTest.php';
require_once 'Services/Flickr/Test/Response/DefaultTest.php';

require_once 'Services/Flickr/Test/Method/EchoTest.php';
require_once 'Services/Flickr/Test/Method/LoginTest.php';


/**
 * AllTests class for Services_Flickr_Test
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @copyright  Copyright 2008 Yusuke Kawasaki
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_AllTests
{
    public static function main()
    {
        PHPUnit_TextUI_TestRunner::run(self::suite());
    }
 
    public static function suite()
    {
        $suite = new PHPUnit_Framework_TestSuite('Services_Flickr_TestTest');

        $suite->addTestSuite('Services_Flickr_TestTest');
        $suite->addTestSuite('Services_Flickr_Test_FactoryTest');
        $suite->addTestSuite('Services_Flickr_Test_RequestTest');
        $suite->addTestSuite('Services_Flickr_Test_Request_DefaultTest');
        $suite->addTestSuite('Services_Flickr_Test_ResponseTest');
        $suite->addTestSuite('Services_Flickr_Test_Response_DefaultTest');

        $suite->addTestSuite('Services_Flickr_Test_Method_EchoTest');
        $suite->addTestSuite('Services_Flickr_Test_Method_LoginTest');

		
        return $suite;
    }
}

if (PHPUnit_MAIN_METHOD == 'Services_Flickr_Test_AllTests::main') {
    Services_Flickr_Test_AllTests::main();
}

?>
