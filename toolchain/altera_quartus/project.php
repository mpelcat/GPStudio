<?php

function generate_project_file($node, $path)
{
	$content='';
	
	$content.="QUARTUS_VERSION = \"13.1\""."\n";
	$content.="PROJECT_REVISION = \"start\""."\n";
	
	// copy all files for block declared in library
	foreach($node->blocks as $block)
	{
		if($block->in_lib)
		{
			foreach($block->files as $file)
			{
				if(!file_exists($block->path.$file->path))
				{
					echo $block->path.$file->path."\n";
					echo "$file->name doesn't exists\n";
				}
				else
				{
					$subpath = 'IP'.DIRECTORY_SEPARATOR.$block->driver.DIRECTORY_SEPARATOR.dirname($file->path);
					
					// create directory
					if(!is_dir($path.DIRECTORY_SEPARATOR.$subpath)) mkdir($path.DIRECTORY_SEPARATOR.$subpath, 0777, true);
					
					// check if copy is needed
					$needToCopy = false;
					if(file_exists($path.DIRECTORY_SEPARATOR.$subpath.DIRECTORY_SEPARATOR.$file->name))
					{
						if(filemtime($block->path.$file->path) > filemtime($path.DIRECTORY_SEPARATOR.$subpath.DIRECTORY_SEPARATOR.$file->name))
						{
							$needToCopy = true;
						}
					}
					else
					{
						$needToCopy = true;
					}
					$file->path=$subpath.DIRECTORY_SEPARATOR.$file->name;
					
					// copy if need
					if($needToCopy)
					{
						if (!copy($block->path.$file->path, $path.DIRECTORY_SEPARATOR.$subpath.DIRECTORY_SEPARATOR.$file->name))
						{
							echo "failed to copy $file->name\n";
						}
					}
				}
			}
		}
	}
	
	// save file if it's different
	$filename = $path.DIRECTORY_SEPARATOR."$node->name.qpf";
	$needToReplace = false;
	
	if(!file_exists($filename)) $needToReplace = true;
	
	if($needToReplace)
	{
		if (!$handle = fopen($filename, 'w'))
		{
			 echo "$filename cannot be openned\n";
			 exit;
		}
		if (fwrite($handle, $content) === FALSE) { echo "$filename cannot be written\n"; exit; }
		fclose($handle);
	}
}

?>
