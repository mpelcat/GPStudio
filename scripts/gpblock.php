<?php

define("LIB_PATH", realpath(dirname(__FILE__)."/..").DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'model');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'system_interconnect');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'support');

require_once("process.php");
require_once("gpstudio.php");

$options = getopt("a:");
if(array_key_exists('a',$options)) $action = $options['a']; else error("You should specify an action with -a"."\n",1);

// new block creation
if($action=="newprocess")
{
	$options = getopt("a:n:");
	if(array_key_exists('n',$options)) $blockName=$options['n']; else error("You should specify a project name with -n"."\n",1);
	
	$block = new Process();
	$block->name=$blockName;
	$blockName.=".proc";
}
else
{
	$blockName=findprocess();
	if(!file_exists($blockName))
	{
		if(strpos($action, "list")===false) error("Cannot find a valid project in the current directory.",1);
	}
	
	$block = new Process($blockName);
}

$save = true;

switch($action)
{
	// =========================== global commands =====================
	case "-h":
	case "--help":
		echo "# gpblock command line tool to manage a gpstudio block (v0.95)"."\n";
		$save = false;
		break;
	case "-v":
	case "--version":
		echo "# gpblock command line tool to manage a gpstudio block (v0.95)"."\n";
		$save = false;
		break;
	
	// =========================== project commands ====================
	case "newprocess":
		// nothing to do
		break;
	
	// =========================== files commands ======================
	case "addfile":
		$options = getopt("a:p:t:g:h:");
		if(array_key_exists('p',$options)) $path = $options['p']; else error("You should specify a path for the file with -p"."\n",1);
		if(array_key_exists('t',$options)) $type = $options['t']; else error("You should specify a type for the file with -t"."\n",1);
		if(array_key_exists('g',$options)) $group = $options['g']; else error("You should specify a group for the file with -g"."\n",1);
		if(array_key_exists('h',$options)) $desc = $options['h']; $desc = "";
		
		if($block->getFileByPath($path)!=NULL) error("This file already exists added with the same path."."\n",1);
		if(!file_exists($path)) warning("This file does not exist, you should create it."."\n",4);
		
		$file = new File();
		$file->name = basename($path);
		$file->path = $path;
		$file->type = $type;
		$file->group = $group;
		$file->desc = $desc;
		
		$block->addFile($file);
		break;
		
	case "delfile":
		$options = getopt("a:p:");
		if(array_key_exists('p',$options)) $path = $options['p']; else error("You should specify a path for the file with -p"."\n",1);
		
		if($block->getFileByPath($path)==NULL) error("A file does not exist with the path '$path'."."\n",1);
		
		$block->delFileByPath($path);
		break;
		
	case "showfile":
		echo "files :" . "\n";
		foreach($block->files as $file)
		{
			echo "  + ".$file. "\n";
		}
		$save = false;
		break;
	
	// ======================= flows interface commands ================
	case "addflow":
		break;
	
}

if($save) $block->saveBlockDef($blockName);

?>
