<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file contains the class "Services_Flickr_Test_Response_Default"
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
require_once 'XML/Unserializer.php';

/**
 * Default implementation of Response class (using XML_Unserializer)
 *
 * @category   Services
 * @package    Services_Flickr_Test
 * @author     Yusuke Kawasaki <u-suke [at] kawa.net>
 * @license    http://www.opensource.org/licenses/bsd-license.php BSD
 * @version    Release: @package_version@
 * @link       http://wsst.googlecode.com/svn/trunk/
 */
class Services_Flickr_Test_Response_Default extends Services_Flickr_Test_Response
{
    /**
     * XML_Unserializer options
     * 
     * @access private
     * @var array
     */
    var $_options = array(XML_UNSERIALIZER_OPTION_COMPLEXTYPE => 'object',
                          XML_UNSERIALIZER_OPTION_ATTRIBUTES_PARSE => TRUE);
    
    /**
     *　set XML_Unserializer option
     * 
     * @access public
     * @param string $key option key
     * @param string $val option value
     */
    function setOption($key, $val)
    {
        $this->_option[$key] = $val;
    }

    /**
     * process response data
     * 
     * @access public
     * @param array $conf config
     * @return void
     */
    function processData($conf = array())
    {
        $options = $this->_options;    
        
        if (array_key_exists('force_array', $conf)) {
            $options[XML_UNSERIALIZER_OPTION_FORCE_ENUM]
                = array_key_exists(XML_UNSERIALIZER_OPTION_FORCE_ENUM, $options)
                  && $options[XML_UNSERIALIZER_OPTION_FORCE_ENUM]
                    ? array_merge($options[XML_UNSERIALIZER_OPTION_FORCE_ENUM],
                                  $conf['force_array'])
                    : $conf['force_array'];
        }
    
        $unserializer =& new XML_Unserializer($options);
        
        // remove dust data
        $content = $this->_content;
        $first = strpos($content, '<');
        $last = strrpos($content, '>');
        $content = substr($content, $first, $last - $first + 1);
        
        $status = $unserializer->unserialize($content, false);
        if (PEAR::isError($status)) {
            $this->processDataError = $status->getMessage();
            return;
        }
        
        $this->_data = $unserializer->getUnserializedData();
    }
}

?>
