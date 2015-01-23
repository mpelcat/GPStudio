<?php

define("LIB_PATH", realpath(dirname(__FILE__)).DIRECTORY_SEPARATOR);
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH);
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH.DIRECTORY_SEPARATOR.'scripts');
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH.DIRECTORY_SEPARATOR.'system_interconnect');
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH.DIRECTORY_SEPARATOR.'toolchain'.DIRECTORY_SEPARATOR.'hdl');

require("node.php");
require_once("vhdl_generator.php");

// create node data structure from config file
$config_block_file = $argv[1];
if(!file_exists($config_block_file))
{
	echo 'The config file does\'nt exist.'."\n";
}

$block = null;
if(substr($config_block_file, -2)==="io")
{
	$block = new IO($config_block_file);
	print_r($block);
}
elseif(substr($config_block_file, -4)==="proc")
{
	
}
else
{
	echo 'The config file is not a know extension.'."\n";
	exit;
}

$block->name=basename($config_block_file);

$generator = new VHDL_generator($block->name);
$generator->fromBlock($block);
$generator->save_as(getcwd().DIRECTORY_SEPARATOR.$block->name.'.vhd');

?>
