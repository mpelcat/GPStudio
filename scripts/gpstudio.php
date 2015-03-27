<?php

$txtred="\e[0;31m"; # Red
$txtorange="\e[0;33m"; # Orange
$txtgreen="\e[0;32m"; # Green
$txtrst="\e[0m";    # Text Reset

$warningCount=0;

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
	global $warningCount;
	
	echo $txtorange;
	if(!empty($warningCtx)) echo "[$warningCtx] ";
	echo "Warning ($warningCode) : ".$warningText."\n";
	echo $txtrst;
	
	$warningCount++;
}

function message($messageText, $messageCtx="")
{
	global $txtrst;
	global $txtgreen;
	
	echo $txtgreen;
	if(!empty($messageCtx)) echo "[$messageCtx] ";
	echo $messageText."\n";
	echo $txtrst;
}

?>
