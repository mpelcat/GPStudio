<?php

require_once("generator/vhdl_generator.php");

function create_header_file($node, $filename)
{
	$content='';
	
	foreach($node->blocks as $block)
	{
		if($block->size_addr_rel>0)
		{
			$count=0;
			foreach($block->params as $param)
			{
				if($param->hard!='1')
				{
					if($count++==0) $content.='// '.str_pad(' '.$block->name.' ',55,'=',STR_PAD_BOTH)."\n";
					$paramname = strtoupper($block->name.'_'.$param->name);
					$value = $block->addr_abs+$param->regaddr;
					$content.="#define ".str_pad($paramname,25)."\t".$value."\n";
					
					foreach($param->enum as $value => $name)
					{
						$content.="	#define ".str_pad(strtoupper($paramname.'_'.$name),40)."\t".$value."\n";
					}
					$content.="\n";
				}
			}
		}
	}
	
	// save file if it's different
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

function generate_bus_interconnect($node, $path)
{
	$generator = new VHDL_generator('bi');
	
	if(!$bi=$node->getBlock('bi')) return;
	$generator->fromBlock($bi);
	
	// find the master name
	$name_master = '';
	$size_master_addr = 0;
	foreach($bi->interfaces as $interface)
	{
		if($interface->type=='bi_master_conn')
		{
			$name_master=$interface->blockname;
			$size_master_addr=$interface->size_addr;
		}
	}
	
	$code='';
	
	$code.="\n";
	// generate for only ONE master
	foreach($bi->interfaces as $interface)
	{
		if($interface->type=='bi_slave_conn')
		{
			$addr_slave_abs = $node->getBlock($interface->blockname)->addr_abs;
			$addr_slave_abs_masked = $addr_slave_abs >> $interface->size_addr;
		
			$name_cs = 'cs_'.$interface->blockname.'_s';
			$name_addr_rel = $interface->blockname.'_addr_rel_o';
			
			$name_wr = $interface->blockname.'_wr_o';
			$name_datawr = $interface->blockname.'_datawr_o';
			
			$name_addr_master = $name_master.'_master_addr_i';
			
			$code.='-- '.$interface->blockname.' slave at addr : '.$addr_slave_abs.' to '.($addr_slave_abs+pow(2,$interface->size_addr)-1)."\n";
			// cs slave
			$code.=$name_wr.' <= '.$name_cs.' and '.$name_master.'_master_wr_i;'."\n";
			// addr relative slave
			$code.=$name_addr_rel.' <= '.$name_addr_master.'('.($interface->size_addr-1).' downto 0);'."\n";
			// write slave
			$code.=$name_datawr.' <= '.$name_master.'_master_datawr_i;'."\n";
			
			// decode address slave
			$code.="\n";
			$code.='decode_'.$interface->blockname.' : process('.$name_master.'_master_addr_i)'."\n";
			$code.='begin'."\n";
			$code.='	if('.$name_addr_master.'('.($size_master_addr-1).' downto '.($interface->size_addr).') = std_logic_vector(to_unsigned('.$addr_slave_abs_masked.', '.($size_master_addr-$interface->size_addr).'))) then'."\n";
			$code.='		'.$name_cs.' <= \'1\';'."\n";
			$code.='	else'."\n";
			$code.='		'.$name_cs.' <= \'0\';'."\n";
			$code.='	end if;'."\n";
			$code.='end process;'."\n";
			
			$code.="\n";
		}
	}
	
	$generator->code=$code;
	
	$filename = $path.DIRECTORY_SEPARATOR.'bus_interconnect.vhd';
	$generator->save_as_ifdiff($filename);
	
	$file = new File();
	$file->name = 'bus_interconnect.vhd';
	$file->group= 'hdl';
	$file->type = 'vhdl';
	array_push($bi->files, $file);
	
	create_header_file($node, $path.DIRECTORY_SEPARATOR.'params.h');
}

?>
