<?php

define("LIB_PATH", realpath(dirname(__FILE__)."/..").DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'model');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'system_interconnect');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'support');

require_once("lib.php");
require_once("gpstudio.php");

$options = getopt("a:");
if(array_key_exists('a',$options)) $action = $options['a']; else error("You should specify an action with -a"."\n",1);

$lib = new Lib(SUPPORT_PATH);

switch($action)
{
	// =========================== global commands =========================== 
	case "-h":
	case "--help":
		echo "# gplib command line tool to manage gpstudio lib (v0.9)"."\n";
		echo "gplib listprocess"."\n";
		echo "gplib listio"."\n";
		echo "gplib listboard"."\n";
		echo "gplib listtoolchain"."\n";
		break;
	case "-v":
	case "--version":
		echo "# gplib command line tool to manage gpstudio lib (v0.9)"."\n";
		break;
	
	// =========================== list commands =========================== 
	case "listprocess":
		echo implode(" ",$lib->process) . "\n";
		break;
		
	case "listio":
		echo implode(" ",$lib->ios) . "\n";
		break;
		
	case "listboard":
		echo implode(" ",$lib->boards) . "\n";
		break;
		
	case "listtoolchain":
		echo implode(" ",$lib->toolchains) . "\n";
		break;
	
	default:
		error("Action $action is unknow.",1);
}


?>
