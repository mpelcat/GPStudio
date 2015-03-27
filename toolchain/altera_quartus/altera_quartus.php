<?php

require_once("toolchain.php");
require_once("toolchain/hdl/hdl.php");

class Altera_quartus_toolchain extends HDL_toolchain
{
	private $nopartitions;
	private $noqsf;
	
	public function configure_project($node)
	{
		global $argv;
		parent::configure_project($node);
		
		if(in_array("nopartitions", $argv)) $this->nopartitions = 1; else $this->nopartitions = 0;
		if(in_array("noqsf", $argv)) $this->noqsf = 1; else $this->noqsf = 0;
	}
	
	public function generate_project($node, $path)
	{
		parent::generate_project($node, $path);
		$this->generate_tcl($node, $path);
		$this->generate_project_file($node, $path);
	}
	
	protected function generate_project_file($node, $path)
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
						warning("$block->path$file->path doesn't exists",5,$block->name);
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
						
						// copy if need
						if($needToCopy)
						{
							if (!copy($block->path.$file->path, $path.DIRECTORY_SEPARATOR.$subpath.DIRECTORY_SEPARATOR.$file->name))
							{
								warning("failed to copy $file->name",5,$block->name);
							}
						}
						
						// update the path file to the new copy path relative to project
						$file->path=$subpath.DIRECTORY_SEPARATOR.$file->name;
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
			if (!$handle = fopen($filename, 'w')) error("$filename cannot be openned",5,"Altera toolchain");
			if (fwrite($handle, $content) === FALSE) error("$filename cannot be written",5,"Altera toolchain");
			fclose($handle);
		}
	}
	
	protected function generate_tcl($node, $path)
	{
		$content='';
		
		// global board attributes
		$content.="# =============== global assignement ===============\n";
		foreach($node->board->toolchain->attributes as $attribute)
		{
			$value = $attribute->value;
			if(strpos($value,' ')!==false and strpos($value,'-section_id')===false) $value = '"'.$value.'"';
			$content.='set_'.$attribute->type.'_assignment -name '.$attribute->name.' '.$value."\n";
		}
		$content.="\n# --------- pins ---------\n";
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
		$content.="\n# --------- files ---------\n";
		$content.='set_global_assignment -name VHDL_FILE top.vhd'."\n";
		
		if($this->nopartitions==0)
		{
			$content.="\n# -------- partitions --------\n";
			$content.='set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top'."\n";
		}
		
		// blocks assignement
		$content.="\n\n# ================================== blocks assignement ==================================\n";
		foreach($node->blocks as $block)
		{
			$content.="\n# **************************************** $block->name ****************************************";
			
			// pins
			if(!empty($block->pins))
			{
				$content.="\n# --------- pins ---------\n";
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
			}
			
			// files
			$content.="\n# --------- files ---------\n";
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
			
			// partitions
			if($this->nopartitions==0)
			{
				$content.="\n# --------- partitions ---------\n";
				if($block->name==$block->driver)
				{
					$instance=$block->driver.':'.$block->name.'_inst';
				}
				else
				{
					$instance=$block->driver.':'.$block->name;
				}
				$partition_name = substr(str_replace('_','',$block->driver), 0, 4).'_'.substr(md5('top/'.$instance), 0, 4);
				$content.="set_instance_assignment -name PARTITION_HIERARCHY $partition_name -to \"$instance\" -section_id \"$instance\""."\n";
				$content.="set_global_assignment -name PARTITION_NETLIST_TYPE POST_SYNTH -section_id \"$instance\""."\n";
				$content.="set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id \"$instance\""."\n";
			}
		}
		
		if($this->noqsf==0)
		{
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
				if (!$handle = fopen($filename, 'w')) error("$filename cannot be openned",5,"Altera toolchain");
				if (fwrite($handle, $content) === FALSE) error("$filename cannot be written",5,"Altera toolchain");
				fclose($handle);
			}
		}
	}
}

?>
