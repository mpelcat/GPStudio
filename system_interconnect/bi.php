<?php

require_once("block.php");

require_once("toolchain/hdl/vhdl_generator.php");

class BusInterconnect extends Block
{
	public $addr_bus_width;

	function __construct()
	{
		parent::__construct();
		$this->name="bi";
		$this->driver="bi";
	}
	
	static function hex($value, $width)
	{
		return '0x'.str_pad(strtoupper(dechex($value)),ceil($width/4.0),'0',STR_PAD_LEFT);
	}
	
	function configure($node, $block)
	{
		$reset = new Reset();
		$reset->name='reset';
		$reset->direction='in';
		$reset->group='reset_n';
		array_push($this->resets, $reset);
		
		// compute the size of the memory bus
		$sum_space_addr_rel = 0;
		foreach($node->blocks as $block)
		{
			if($block->size_addr_rel>0)
			{
				$size_addr_space = pow(2, $block->size_addr_rel);
				$sum_space_addr_rel += $size_addr_space;
			}
		}
		$this->addr_bus_width = ceil(log($sum_space_addr_rel,2));
		
		// compute the adress relative of each block
		$max_addr = pow(2, $this->addr_bus_width) - 1;
		$addr_space = array_fill(0, $max_addr, -1);
		foreach($node->blocks as $block)
		{
			if($block->size_addr_rel>0)
			{
				$size_addr_space = pow(2, $block->size_addr_rel);
				for($addr=0; $addr<$max_addr; $addr+=$size_addr_space)
				{
					if($addr_space[$addr]==-1)
					{
						$block->addr_abs = $addr;
						array_push($block->interfaces, new InterfaceBus("bus_sl",$block->name,"bi_slave",$block->size_addr_rel));
						array_push($this->interfaces, new InterfaceBus("bus_sl_$block->name",$block->name,"bi_slave_conn",$block->size_addr_rel));
						for($i=0; $i<$size_addr_space; $i++) $addr_space[$addr+$i]=0;
						break;
					}
				}
			}
			if($block->master_count>0)
			{
				for($i=0; $i<$block->master_count; $i++)
				{
					array_push($block->interfaces, new InterfaceBus("bus_master",$block->name,"bi_master",$this->addr_bus_width));
					array_push($this->interfaces, new InterfaceBus("bus_master_$block->name",$block->name,"bi_master_conn",$this->addr_bus_width));
					
					$param = new Param();
					$param->name = 'MASTER_ADDR_WIDTH';
					$param->value = $this->addr_bus_width;
					$param->hard = true;
					array_push($block->params, $param);
				}
			}
		}
		
		/*echo "\n" . '// =============== Slaves addr ===============' . "\n";
		foreach($node->blocks as $block)
		{
			if($block->size_addr_rel>0)
			{
				echo $block->name . ' : ' . $block->addr_abs . "\n";
			}
		}*/
	}
	
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
					if($param->hard==false)
					{
						if($count++==0) $content.="\n".'// '.str_pad(' '.$block->name.' ',55,'-',STR_PAD_BOTH)."\n";
						$paramname = strtoupper($block->name.'_'.$param->name);
						$value = $block->addr_abs+$param->regaddr;
						$content.="#define ".str_pad($paramname,25)."\t".BusInterconnect::hex($value,$this->addr_bus_width);
						if(!empty($param->desc)) $content.="\t// ".$param->desc;
						$content.="\n";
					
						foreach($param->parambitfields as $parambitfield)
						{
							$mask=0;
							foreach($parambitfield->bitfieldlist as $bitfield) $mask += pow(2, $bitfield);
							$content.="	#define ".str_pad(strtoupper($paramname.'_'.$parambitfield->name.'_MASK'),40)."\t".BusInterconnect::hex($mask,32)."\n";
							
							foreach($parambitfield->paramenums as $paramenum)
							{
								$content.="		#define ".str_pad(strtoupper($paramname.'_'.$paramenum->name),40)."\t".BusInterconnect::hex($paramenum->value,32);
								if(!empty($enum->desc)) $content.="\t// ".$paramenum->desc;
								$content.="\n";
							}
						}
						if(!empty($param->parambitfields)) $content.="\n";
					}
				}
				
				foreach($block->properties as $property)
				{
					foreach($property->propertyenums as $propertyenum)
					{
						$content.="	#define ".str_pad(strtoupper($property->name.'_'.$propertyenum->name),40)."\t".BusInterconnect::hex($propertyenum->value,32);
						if(!empty($enum->desc)) $content.="\t// ".$paramenum->desc;
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

	function generate($node, $block, $path, $language)
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
				if($interface->size_addr==1)
				{
					$code.=$name_addr_rel.' <= '.$name_addr_master.'(0);'."\n";
				}
				else
				{
					$code.=$name_addr_rel.' <= '.$name_addr_master.'('.($interface->size_addr-1).' downto 0);'."\n";
				}
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
	
		$this->create_header_file($node, $path.DIRECTORY_SEPARATOR.'params.h');
	}
	
	public function type() {return 'bi';}
	
	public function getXmlElement($xml)
	{
		$xml_element = parent::getXmlElement($xml);
		
		return $xml_element;
	}
}

?>
