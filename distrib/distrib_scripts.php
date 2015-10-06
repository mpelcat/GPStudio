<?php

function distrib_scripts()
{
	// create directory
	mkdirExists(WIN_DISTRIB_PATH."scripts");
	mkdirExists(WIN_DISTRIB_PATH."scripts".DIRECTORY_SEPARATOR."model");
	mkdirExists(WIN_DISTRIB_PATH."scripts".DIRECTORY_SEPARATOR."system_interconnect");

	mkdirExists(LINUX_DISTRIB_PATH."scripts");
	mkdirExists(LINUX_DISTRIB_PATH."scripts".DIRECTORY_SEPARATOR."model");
	mkdirExists(LINUX_DISTRIB_PATH."scripts".DIRECTORY_SEPARATOR."system_interconnect");

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
				
				$filename = WIN_DISTRIB_PATH . $path . $file;
				$handle_write = fopen($filename, 'w');
				fwrite($handle_write, $content_file);
				fclose($handle_write);
				
				$filename = LINUX_DISTRIB_PATH . $path . $file;
				$handle_write = fopen($filename, 'w');
				fwrite($handle_write, $content_file);
				fclose($handle_write);
			}
		}
	}
}

?>
