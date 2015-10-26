<?php

$version_cache = '';
$license_cache = '';

function getVersion()
{
	global $version_cache;
	if(empty($version_cache))
	{
		$filename = LIB_PATH.DIRECTORY_SEPARATOR.'version';
		$handle = fopen($filename, 'r');
		$version_cache = fread($handle, filesize($filename));
		
		$version_cache = str_replace("\n","",$version_cache);
		$version_cache = str_replace("\r","",$version_cache);
		
		exec("cat ".LIB_PATH.".git/ORIG_HEAD", $out);
		
		$version_cache.=" based on repo ".$out[0];
		
		fclose($handle);
	}
	return $version_cache;
}

function getLicense()
{
	global $license_cache;
	if(empty($license_cache))
	{
		$filename = DISTRIB_PATH.DIRECTORY_SEPARATOR.'license';
		$handle = fopen($filename, 'r');
		$license_cache = fread($handle, filesize($filename));
		$license_cache = str_replace('%%version%%',getVersion(),$license_cache);
		$license_cache = str_replace('%%date%%',date('Y-m-d H:i'),$license_cache);
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

function copy_with_rights($src, $dest)
{
	copy($src, $dest);
	$srcright = fileperms($src);
	if(fileperms($dest)!=$srcright) chmod($dest, $srcright);
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

?>
