<?php

define("LIB_PATH", realpath(dirname(__FILE__).DIRECTORY_SEPARATOR.'..').DIRECTORY_SEPARATOR);
define("GUI_TOOLS_PATH", LIB_PATH . "gui-tools" . DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
define("DISTRIB_PATH", realpath(dirname(__FILE__)).DIRECTORY_SEPARATOR);
define("WIN_DISTRIB_PATH", DISTRIB_PATH."gpstudio_win".DIRECTORY_SEPARATOR);
define("LINUX_DISTRIB_PATH", DISTRIB_PATH."gpstudio_linux".DIRECTORY_SEPARATOR);

include("distrib_utils.php");
include("distrib_scripts.php");
include(LIB_PATH."scripts".DIRECTORY_SEPARATOR."gpstudio.php");

function distrib($os)
{
	if($os=="win") $path=WIN_DISTRIB_PATH; else $path=LINUX_DISTRIB_PATH;
	
	mkdirExists($path);
	
	distrib_scripts($path, $os);
	distrib_support($path, $os);
	distrib_doc($path, $os);
	distrib_bin($path, $os);
	distrib_thirdparts($path, $os);
}

$options = getopt("o:");
if(array_key_exists('o',$options)) $os = $options['o']; else exit("You should specify an os with -o");

distrib($os);

?>
