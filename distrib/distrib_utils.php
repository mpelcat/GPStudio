<?php

$version_cache = '';
$license_cache = '';

function getVersion()
{
	if(empty($version_cache))
	{
		$filename = LIB_PATH.DIRECTORY_SEPARATOR.'version';
		$handle = fopen($filename, 'r');
		$version_cache = fread($handle, filesize($filename));
		
		$version_cache = str_replace("\n","",$version_cache);
		$version_cache = str_replace("\r","",$version_cache);
		
		fclose($handle);
	}
	return $version_cache;
}

function getLicense()
{
	if(empty($license_cache))
	{
		$filename = DISTRIB_PATH.DIRECTORY_SEPARATOR.'license';
		$handle = fopen($filename, 'r');
		$license_cache = fread($handle, filesize($filename));
		$license_cache = str_replace('%%version%%',getVersion(),$license_cache);
		$license_cache = str_replace('%%date%%',date('Y-m-d'),$license_cache);
		fclose($handle);
	}
	return $license_cache;
}

function getComments($text,$type)
{
	if($type=="c")
	{
		return "/**"."\n".$text."**/"."\n"."\n";
	}
	elseif($type=="vhdl")
	{
		return '-- '.str_replace("\n","\n-- ",$text)."\n"."\n";
	}
	elseif($type=="php")
	{
		return "<?php"."\n"."/**"."\n".$text."**/"."\n"."?>"."\n"."\n";
	}
	else return $text;
}

function mkdirExists($dir)
{
	if(!file_exists($dir)) mkdir($dir);
}


?>
