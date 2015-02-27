<?php

function generate_tcl($node, $path)
{
	$content='';
	
	// global board attributes
	foreach($node->board->toolchain->attributes as $attribute)
	{
		$value = $attribute->value;
		if(strpos($value,' ')!==false and strpos($value,'-section_id')===false) $value = '"'.$value.'"';
		$content.='set_'.$attribute->type.'_assignment -name '.$attribute->name.' '.$value."\n";
	}
	
	// pins assignement
	$content.="# ================ pins assignement ================\n";
	foreach($node->board->pins as $pin)
	{
		if(!empty($pin->mapto)) $content.='set_location_assignment '.$pin->name.' -to '.$pin->mapto."\n";
		foreach($pin->attributes as $attribute)
		{
			$value = $attribute->value;
			if(strpos($value,' ')!==false and strpos($value,'-section_id')===false) $value = '"'.$value.'"';
			$content.='set_'.$attribute->type.'_assignment -name '.$attribute->name.' '.$value.' -to '.$pin->name."\n";
		}
	}
	foreach($node->blocks as $block)
	{
		if(!empty($block->pins))
		{
			$content.="# ----- $block->name -----\n";
			foreach($block->pins as $pin)
			{
				if(!empty($pin->mapto)) $content.='set_location_assignment '.$pin->name.' -to '.$block->name.'_'.$pin->mapto."\n";
				foreach($pin->attributes as $attribute)
				{
					$value = $attribute->value;
					if(strpos($value,' ')!==false and strpos($value,'-section_id')===false) $value = '"'.$value.'"';
					$content.='set_'.$attribute->type.'_assignment -name '.$attribute->name.' '.$value.' -to '.$pin->name."\n";
				}
			}
			$content.="\n";
		}
	}
	
	// files
	$content.="# ================ files assignement ================\n";
	$content.='set_global_assignment -name VHDL_FILE top.vhd'."\n";
	foreach($node->blocks as $block)
	{
		if(!empty($block->files))
		{
			foreach($block->files as $file)
			{
				if($file->group=="hdl")
				{
					$type='';
					if($file->type=="verilog") {$type='VERILOG_FILE';}
					elseif($file->type=="vhdl") {$type='VHDL_FILE';}
					elseif($file->type=="qip") {$type='QIP_FILE';}
					elseif($file->type=="sdc") {$type='SDC_FILE';}
					elseif($file->type=="hex") {$type='HEX_FILE';}
					
					if($block->in_lib)
					{
						$subpath = 'IP'.DIRECTORY_SEPARATOR.$block->driver.DIRECTORY_SEPARATOR.dirname($file->path);
					}
					else
					{
						$subpath = dirname($file->path);
					}
					if(!empty($subpath)) $subpath .= DIRECTORY_SEPARATOR;
					$content.="set_global_assignment -name $type ".$subpath.$file->name."\n";
				}
			}
		}
	}
	
	// save file if it's different
	$filename = $path.DIRECTORY_SEPARATOR."$node->name.qsf";
	$needToReplace = false;
	
	if(file_exists($filename))
	{
		$handle = fopen($filename, 'r');
		$actualContent = fread($handle, filesize($filename));
		fclose($handle);
		if($actualContent != $content) $needToReplace = true;
	}
	else $needToReplace = true;
	
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
