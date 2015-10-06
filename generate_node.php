<?php

define("LIB_PATH", realpath(dirname(__FILE__)).DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'model');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'system_interconnect');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'support');

require_once("node.php");
require_once("gpstudio.php");

if(count($argv)<2) error("Please give a config file node as argument."."\n",1);
$config_node_file = $argv[1];
if(!file_exists($config_node_file)) error("The config file '$config_node_file' does'nt exist.",1);

// create node data structure from config file
$node = new Node($config_node_file);

// create toolchain depend of the config node
//$toolchain = Toolchain::load('altera_quartus');
$toolchain = $node->board->toolchain;
$toolchain->configure_project($node);
$toolchain->generate_project($node, getcwd());

$node->saveXml("node_generated.xml");
message("Project successfully generated ($warningCount warnings).");

?>
