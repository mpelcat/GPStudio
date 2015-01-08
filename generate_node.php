<?php

require("scripts".DIRECTORY_SEPARATOR."node.php");

define("LIB_PATH", realpath(dirname(__FILE__)).DIRECTORY_SEPARATOR);
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH.DIRECTORY_SEPARATOR.'scripts');

$node = new Node($argv[1]);

include("toolchain/altera_quartus_cyclone3/altera_quartus_cyclone3.php");

generate($node, getcwd());

?>
