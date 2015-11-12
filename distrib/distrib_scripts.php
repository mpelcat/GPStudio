<?php

function distrib_scripts($mainoutpath, $os)
{
	echo "copying scripts files in $mainoutpath for $os..."."\n";
	
	// create directory
	mkdirExists($mainoutpath."scripts");
	mkdirExists($mainoutpath."scripts".DIRECTORY_SEPARATOR."model");
	mkdirExists($mainoutpath."scripts".DIRECTORY_SEPARATOR."system_interconnect");

	// copy scripts and prepend license file
	$paths = array(	'scripts'.DIRECTORY_SEPARATOR,
					'scripts'.DIRECTORY_SEPARATOR.'model'.DIRECTORY_SEPARATOR,
					'scripts'.DIRECTORY_SEPARATOR.'system_interconnect'.DIRECTORY_SEPARATOR);
	foreach($paths as $path)
	{
		$files = scandir(LIB_PATH.$path);
		foreach($files as $file)
		{
			if(substr($file,-4)===".php")
			{
				$filename = LIB_PATH . $path . $file;
				
				$handle_read = fopen($filename, 'r');
				$content_file = getComments(getLicense(),"php");
				$content_file .= fread($handle_read, filesize($filename));
				fclose($handle_read);
				
				$filename = $mainoutpath . $path . $file;
				$handle_write = fopen($filename, 'w');
				fwrite($handle_write, $content_file);
				fclose($handle_write);
			}
		}
	}
	echo "done."."\n";
}

function distrib_support($mainoutpath, $os)
{
	echo "copying support files in $mainoutpath for $os..."."\n";
	
	// create directory
	mkdirExists($mainoutpath."support");
	
	foreach(array("board", "io", "process", "toolchain") as $dir)
	{
		$path = $mainoutpath."support".DIRECTORY_SEPARATOR.$dir.DIRECTORY_SEPARATOR;
		mkdirExists($path);
		
		$filename = DISTRIB_PATH.$dir.".txt";
		$handle_read = fopen($filename, 'r');
		
		if($handle_read)
		{
			while(($line = fgets($handle_read)) !== false)
			{
				$line = str_replace("\n","",$line);
				$line = str_replace("\r","",$line);
				
				$ip = $line;
				echo "	+ ".$dir." ".$ip."\n";
				
				mkdirExists($path.$ip);
				cpy_dir(SUPPORT_PATH.$dir.DIRECTORY_SEPARATOR.$ip, $path.$ip);
			}
			fclose($handle_read);
		}
	}
	echo "done."."\n";
}

function distrib_doc($mainoutpath, $os)
{
	echo "copying doc files in $mainoutpath for $os..."."\n";
	
	// create directory
	mkdirExists($mainoutpath."doc");
	cpy_dir(LIB_PATH."doc", $mainoutpath."doc");
	echo "done."."\n";
}

function distrib_bin($mainoutpath, $os)
{
	echo "copying bin files in $mainoutpath for $os..."."\n";
	
	// create directory
	mkdirExists($mainoutpath."bin");
	
	if($os=="win")
	{
		copy_with_rights(LIB_PATH."bin/gpnode.bat", $mainoutpath."bin".DIRECTORY_SEPARATOR."gpnode.bat");
	}
	else
	{
		copy_with_rights(LIB_PATH."bin/gpnode", $mainoutpath."bin".DIRECTORY_SEPARATOR."gpnode");
		copy_with_rights(LIB_PATH."setenv.sh", $mainoutpath.DIRECTORY_SEPARATOR."setenv.sh");
	}
	echo GUI_TOOLS_PATH."bin-$os";
	cpy_dir(GUI_TOOLS_PATH."bin-$os", $mainoutpath."bin");
	
	// copy lib_bin
	$lib_bin_dir = LIB_PATH."distrib".DIRECTORY_SEPARATOR."lib_bin".DIRECTORY_SEPARATOR.$os;
	if(file_exists($lib_bin_dir))
	{
		cpy_dir($lib_bin_dir, $mainoutpath."bin");
	}
	
	echo "done."."\n";
}

function distrib_thirdparts($mainoutpath, $os)
{
	echo "copying thirdparts files in $mainoutpath for $os..."."\n";
	
	$thirdparts_dir = LIB_PATH."distrib".DIRECTORY_SEPARATOR."thirdparts".DIRECTORY_SEPARATOR.$os;
	if(file_exists($thirdparts_dir))
	{
		// create directory
		mkdirExists($mainoutpath."thirdparts");
		cpy_dir($thirdparts_dir, $mainoutpath."thirdparts");
	}
	echo "done."."\n";
}

?>
