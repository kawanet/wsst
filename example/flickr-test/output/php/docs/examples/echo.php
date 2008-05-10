<?php

/**
 * Example of Services_Flickr_Test::echo
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

error_reporting(E_ALL);
ini_set('display_errors', true);

require_once 'Services/Flickr/Test.php';

// create Services_Flickr_Test object.
$service =& new Services_Flickr_Test();

// call echo and get response.
$params = array(
    'api_key' => getenv('FLICKR_API_KEY'),
);
$res =& $service->echo($params);

// check library error.
if (PEAR::isError($res)) {
    echo "Error: " . $res->getMessage() . "\n";
    exit(1);
}

// get response data.
$data =& $res->getData();

// print response data.
echo "stat: {$data->stat}\n";
echo "method: {$data->method}\n";
echo "api_key: {$data->api_key}\n";


?>
