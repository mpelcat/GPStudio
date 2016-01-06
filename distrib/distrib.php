<?php

define("LIB_PATH", realpath(dirname(__FILE__).DIRECTORY_SEPARATOR.'..').DIRECTORY_SEPARATOR);
define("GUI_TOOLS_PATH", LIB_PATH . "gui-tools" . DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
define("DISTRIB_PATH", realpath(dirname(__FILE__)).DIRECTORY_SEPARATOR);

include("distrib_utils.php");
include("distrib_scripts.php");
include(LIB_PATH."scripts".DIRECTORY_SEPARATOR."gpstudio.php");

function distrib($system, $archi, $qtver, $outdir)
{
	mkdirExists($outdir);
	$outdir=realpath($outdir).DIRECTORY_SEPARATOR;
	echo $outdir;
	
	distrib_scripts($outdir, $system, $archi, $qtver);
	distrib_support($outdir, $system, $archi, $qtver);
	distrib_doc($outdir, $system, $archi, $qtver);
	distrib_bin($outdir, $system, $archi, $qtver);
	distrib_thirdparts($outdir, $system, $archi, $qtver);
}

$options = getopt("s:a:q:o:");
if(array_key_exists('s',$options)) $system = $options['s']; else exit("You should specify a system with -s [win-linux]\n");
if(array_key_exists('a',$options)) $archi = $options['a']; else exit("You should specify an architechture with -a [32-64]\n");
if(array_key_exists('q',$options)) $qtver = $options['q']; else exit("You should specify a qt version with -q [4-5]\n");
if(array_key_exists('o',$options)) $outdir = $options['o']; else exit("You should specify an output dir with -o\n");

distrib($system, $archi, $qtver, $outdir);

?>
