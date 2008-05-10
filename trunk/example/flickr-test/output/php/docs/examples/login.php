<?php

/**
 * Example of Services_Flickr_Test::login
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

// call login and get response.
$params = array(
    'api_key' => getenv('FLICKR_API_KEY'),
    'api_sig' => getenv('FLICKR_API_SIG'),
    'auth_token' => getenv('FLICKR_AUTH_TOKEN'),
);
$res =& $service->login($params);

// check library error.
if (PEAR::isError($res)) {
    echo "Error: " . $res->getMessage() . "\n";
    exit(1);
}

// get response data.
$data =& $res->getData();

// print response data.
echo "stat: {$data->stat}\n";
echo "id: {$data->user->id}\n";
echo "username: {$data->user->username}\n";


?>
