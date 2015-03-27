<?php

define("LIB_PATH", realpath(dirname(__FILE__)).DIRECTORY_SEPARATOR);
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH);
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH.DIRECTORY_SEPARATOR.'scripts');
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH.DIRECTORY_SEPARATOR.'system_interconnect');
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH.DIRECTORY_SEPARATOR.'toolchain'.DIRECTORY_SEPARATOR.'hdl');

require("gpstudio.php");
require("node.php");
require_once("vhdl_generator.php");

// create node data structure from config file
$config_block_file = $argv[1];
if(!file_exists($config_block_file)) error('The config file does\'nt exist.',1);

$block = null;
if(substr($config_block_file, -3)===".io")
{
	$block = new IO($config_block_file);
}
elseif(substr($config_block_file, -5)===".proc")
{
	$block = new Process($config_block_file);
}
else error('The config file is not a know extension.',1);

$block->name=preg_replace('/\\.[^.\\s]{2,5}$/', '', basename($config_block_file));
if($block->size_addr_rel>0) array_push($block->interfaces, new InterfaceBus("bus_sl",$block->name,"bi_slave",$block->size_addr_rel));

$generator = new VHDL_generator($block->name);
$generator->fromBlock($block);
$generator->save_as($block->path.DIRECTORY_SEPARATOR.$block->name.'.vhd');

echo $block->name.'.vhd'.' generated'."\n";

?>
