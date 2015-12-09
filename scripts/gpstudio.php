<?php

/**
 * @mainpage
 * 
 * This document is the complete documentation of GPStudio backend. It composed of two parts :
 * 	- the model and backend develloper documentation
 * 	- the user guide documentation
 * 
 * @section modelbckend model and backend
 * 
 * @section usrguide user guide
 * 
 * @defgroup base Base script model
**/

if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN')
{
	$txtred=""; # Red
	$txtorange=""; # Orange
	$txtgreen=""; # Green
	$txtrst="";    # Text Reset
}
else
{
    $txtred="\e[0;31m"; # Red
	$txtorange="\e[0;33m"; # Orange
	$txtgreen="\e[0;32m"; # Green
	$txtrst="\e[0m";    # Text Reset
}

$warningCount=0;
$lastCtx='';
$setVerbosityOption=true;

function setVerbosity($option)
{
	global $setVerbosityOption;
	$setVerbosityOption = $option;
}

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
	global $lastCtx;
	global $setVerbosityOption;
	
	if($setVerbosityOption)
	{
		if($lastCtx!='' and $lastCtx!=$warningCtx) echo "\n";
		
		echo $txtorange;
		if(!empty($warningCtx)) echo "[$warningCtx] ";
		echo "Warning ($warningCode) : ".$warningText."\n";
		echo $txtrst;
		
		$warningCount++;
		$lastCtx=$warningCtx;
	}
}

function message($messageText, $messageCtx="")
{
	global $txtrst;
	global $txtgreen;
	global $lastCtx;
	global $setVerbosityOption;
	
	if($setVerbosityOption)
	{
		if($lastCtx!='' and $lastCtx!=$messageCtx) echo "\n";
		
		echo $txtgreen;
		if(!empty($messageCtx)) echo "[$messageCtx] ";
		echo $messageText."\n";
		echo $txtrst;
		
		$lastCtx=$messageCtx;
	}
}

function messageVerbosity($messageText, $messageCtx="")
{
	global $argv;
	if(in_array("verbosity", $argv))
	{
		message($messageText, $messageCtx);
	}
}

function findproject()
{
	$projects = array();
	$files = scandir(getcwd());
	foreach($files as $file)
	{
		if(substr($file,-5)===".node")
		{
			$projects[]=$file;
		}
	}
	if(count($projects)==1) return $projects[0]; else return '';
}

function listprocess()
{
	$directory = SUPPORT_PATH."process".DIRECTORY_SEPARATOR;
	echo $directory;
	$files = scandir($directory);
	foreach($files as $file)
	{
		if($file!='.' and $file!='..')
		{
			echo $file." ";
		}
	}
}

function listio()
{
	$directory = SUPPORT_PATH."io".DIRECTORY_SEPARATOR;
	echo $directory;
	$files = scandir($directory);
	foreach($files as $file)
	{
		if($file!='.' and $file!='..')
		{
			echo $file." ";
		}
	}
}

function copy_with_rights($src, $dest)
{
	copy($src, $dest);
	$srcright = fileperms($src);
	if(file_exists($dest))
	{
		if(fileperms($dest)!=$srcright) chmod($dest, $srcright);
	}
	else chmod($dest, $srcright);
}

function cpy_dir($source, $dest)
{
    if(is_dir($source))
    {
        $dir_handle=opendir($source);
        while($file=readdir($dir_handle))
        {
            if($file!="." && $file!="..")
            {
                if(is_dir($source.DIRECTORY_SEPARATOR.$file))
                {
                    if(!is_dir($dest.DIRECTORY_SEPARATOR.$file))
                    {
                        mkdir($dest.DIRECTORY_SEPARATOR.$file);
                    }
                    cpy_dir($source.DIRECTORY_SEPARATOR.$file, $dest.DIRECTORY_SEPARATOR.$file);
                }
                else
                {
					if(is_link($source.DIRECTORY_SEPARATOR.$file))
					{
						symlink(readlink($source.DIRECTORY_SEPARATOR.$file), $dest.DIRECTORY_SEPARATOR.$file);
					}
                    else
					{
						copy_with_rights($source.DIRECTORY_SEPARATOR.$file, $dest.DIRECTORY_SEPARATOR.$file);
					}
                }
            }
        }
        closedir($dir_handle);
    }
    else
    {
        copy_with_rights($source, $dest);
    }
}

function getRelativePath($path, $dir)
{
	$path=realpath($path);
	$dir=realpath($dir);
	
	if(is_dir($path))
	{
		$dirSrc = realpath($path);
		$srcName = '';
	}
	else
	{
		$dirSrc = dirname($path);
		$srcName = basename($path);
	}
	
	if($dirSrc==$dir)
	{
		return $srcName; // file in dir
	}
	
	if(strpos($dir, $dirSrc)===0)
	{
		$back_dir = str_replace($dirSrc, "", $dir);
		$back_count = substr_count($back_dir, DIRECTORY_SEPARATOR);
		return str_repeat("..".DIRECTORY_SEPARATOR, $back_count).$srcName;
	}
	
	if(strpos($dirSrc, $dir)===0)
	{
		$back_dir = str_replace($dir.DIRECTORY_SEPARATOR, "", $dirSrc);
		return $back_dir;
	}
	
	return $path;
}

?>
