<?php

function generate_tcl($node, $path)
{
	$content='';
	
	$content.='set_global_assignment -name FAMILY "Cyclone III"'."\n";
	$content.='set_global_assignment -name DEVICE '.$node->board->type."\n";
	$content.='set_global_assignment -name TOP_LEVEL_ENTITY top'."\n";
	$content.='set_global_assignment -name ORIGINAL_QUARTUS_VERSION 13.1'."\n";
	//$content.='set_global_assignment -name PROJECT_CREATION_TIME_DATE "'.date("H:i:s  F d, Y").'"'."\n";
	$content.='set_global_assignment -name LAST_QUARTUS_VERSION 13.1'."\n";
	$content.='set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files'."\n";
	$content.='set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0'."\n";
	$content.='set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85'."\n";
	$content.='set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1'."\n";
	$content.='set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V'."\n";
	$content.='set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top'."\n";
	$content.='set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top'."\n";
	$content.='set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top'."\n";
	$content.='set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"'."\n";
	$content.='set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top'."\n";
	
	// pins assignement
	$content.="# ================ pins assignement ================\n";
	foreach($node->board->pins as $pin)
	{
		$content.='set_location_assignment '.$pin->mapto.' -to '.$pin->name."\n";
	}
	foreach($node->blocks as $block)
	{
		if(!empty($block->pins))
		{
			$content.="# ----- $block->name -----\n";
			foreach($block->pins as $pin)
			{
				$content.='set_location_assignment '.$pin->mapto.' -to '.$pin->name."\n";
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
