<?php

$txtred="\e[0;31m"; # Red
$txtorange="\e[0;33m"; # Orange
$txtrst="\e[0m";    # Text Reset

function error($errorText, $errorCode, $errorCtx="")
{
	global $txtrst;
	global $txtred;
	
	echo $txtred;
	if(!empty($errorCtx)) echo "[$errorCtx] ";
	echo "Error ($errorCode) : ".$errorText."\n";
	echo $txtrst;
	exit(1);
}

function warning($warningText, $warningCode, $warningCtx="")
{
	global $txtrst;
	global $txtorange;
	
	echo $txtorange;
	if(!empty($warningCtx)) echo "[$warningCtx] ";
	echo "Warning ($warningCode) : ".$warningText."\n";
	echo $txtrst;
}

?>
