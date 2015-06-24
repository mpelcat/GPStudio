<?php

require_once("block.php");
require_once("flow_connect.php");

require_once("toolchain/hdl/vhdl_generator.php");

class FlowInterconnect extends Block
{
	public $tree_connects;

	/**
	* Flow connections between blocks
	* @var array|FlowConnect $flow_connects
	*/
	public $flow_connects;

	function __construct()
	{
		parent::__construct();
		$this->name="fi";
		$this->driver="fi";
		
		$this->flow_connects = array();
	}
	
	static function showConnect($connect)
	{
		$str = "     in : <connect fromblock=\"$connect->fromblock\" fromflow=\"$connect->fromflow\" toblock=\"$connect->toblock\" toflow=\"$connect->toflow\"/>\n";
		return $str;
	}
	
	static function showFlows($block, $dir)
	{
		$str = "     Available flows $dir for $block->name : ";
		$count=0;
		foreach($block->flows as $flow)
		{
			if($flow->type==$dir)
			{
				$str .= "$flow->name, ";
				$count++;
			}
		}
		if($count==0) $str .= "\tNo flow $dir available";
		return $str;
	}
	
	static function showBlocks($node)
	{
		$str = "     Available blocks : ";
		foreach($node->blocks as $block)
		{
			if($block->name!="fi" and $block->name!="bi" and $block->name!="ci" and $block->name!="ri")
			{
				$str .= "$block->name, ";
			}
		}
		return $str;
	}
	
	protected function parse_xml($xml)
	{
		if(isset($xml->flow_interconnect))
		{
			if(isset($xml->flow_interconnect->connects))
			{
				foreach($xml->flow_interconnect->connects->connect as $connect)
				{
					$this->addFlowConnect(new FlowConnect($connect));
				}
			}
		}
	}
	
	function configure($node, $block)
	{
		$this->parse_xml($node->xml);
		
		$reset = new Reset();
		$reset->name='reset';
		$reset->direction='in';
		$reset->group='reset_n';
		$this->addReset($reset);
		
		foreach($node->blocks as $block)
		{
			foreach($block->flows as $flow)
			{
				if($flow->type=='in' or $flow->type=='out')
				{
					$flow_interface = new Flow();
					$flow_interface->name = $block->name . '_' . $flow->name;
					$flow_interface->type = $flow->type.'_conn';
					$flow_interface->size = $flow->size;

					$this->addFlow($flow_interface);
					//$this->addParam(new Param());
				}
			}
		}
			
		// compute connexion
		$tree_connects = array();
		foreach($this->flow_connects as $connect)
		{
			// check connexion
			if(!$fromblock=$node->getBlock($connect->fromblock))
			{
				warning("Block '$connect->fromblock' doesn't exists. Please check your flow_interconnect->connects section.\n"
				.FlowInterconnect::showConnect($connect)
				.FlowInterconnect::showBlocks($node),15,"FI");
				continue;
			}
			if(!$fromflow=$fromblock->getFlow($connect->fromflow))
			{
				warning("Flow '$connect->fromflow' doesn't exists in block '$connect->fromblock'. Please check your flow_interconnect->connects section."."\n"
				.FlowInterconnect::showConnect($connect)
				.FlowInterconnect::showFlows($fromblock, "out"),15,"FI");
				continue;
			}
			if(!$toblock=$node->getBlock($connect->toblock))
			{
				warning("Block '$connect->toblock' doesn't exists. Please check your flow_interconnect->connects section.\n"
				.FlowInterconnect::showConnect($connect)
				.FlowInterconnect::showBlocks($node),15,"FI");
				continue;
			}
			if(!$toflow=$toblock->getFlow($connect->toflow))
			{
				warning("Flow '$connect->toflow' doesn't exists in block '$connect->toblock'. Please check your flow_interconnect->connects section.\n"
				.FlowInterconnect::showConnect($connect)
				.FlowInterconnect::showFlows($toblock, "in"),15,"FI");
				continue;
			}
			
			// create tree of connexions
			if(!array_key_exists($toblock->name.'_'.$toflow->name, $tree_connects))
			{
				$tree_connects[$toblock->name.'_'.$toflow->name] = array();
				$tree_connects[$toblock->name.'_'.$toflow->name]['size'] = $toflow->size;
				$tree_connects[$toblock->name.'_'.$toflow->name]['order'] = $connect->order;
			}
			array_push($tree_connects[$toblock->name.'_'.$toflow->name], array('name' => $fromblock->name.'_'.$fromflow->name, 'size' => $fromflow->size, 'order' => $connect->order));
		}
		
		/*echo "\n" . '// =============== Flow connections ===============' . "\n";
		print_r($tree_connects);*/
		$this->tree_connects = $tree_connects;
		
		// create params for each mux
		$count_param=0;
		foreach($this->tree_connects as $in_connect => $out_connects)
		{
			if(count($out_connects)-2>1)
			{
				$param = new Param();
				$param->name = $in_connect;
				$param->regaddr = $count_param;
				$param->default = 0;
				$param->hard = false;
				$param->desc = 'Mux control for '.$in_connect.' flow input';
				
				$parambitfield = new ParamBitfield();
				$parambitfield->name = 'muxdir';
				$parambitfield->default = 0;
				$parambitfield->propertymap = $in_connect.".bits";
				
				$this->addParam($param);
				
				$property = new Property();
				$property->name = $in_connect;
				$property->type = 'enum';
				
				foreach($out_connects as $key => $out_connect)
				{
					if(is_numeric($key))
					{
						$propertyenum = new PropertyEnum();
						$propertyenum->name = $out_connect['name'];
						$propertyenum->value = $key;
						$propertyenum->desc = $out_connect['name'].' as input of '.$in_connect;
						
						array_push($property->propertyenums, $propertyenum);
					}
				}
				
				$bitcountenum = ceil(log(count($property->propertyenums),2));
				for($i=0; $i<$bitcountenum; $i++) array_push($parambitfield->bitfieldlist, $i);
				if($bitcountenum>1) $parambitfield->bitfield = ($bitcountenum-1)."-0";
				else $parambitfield->bitfield = "0";
				
				array_push($param->parambitfields, $parambitfield);
				
				$this->addProperty($property);
				
				$count_param++;
			}
		}
		
		if($count_param==1) $this->size_addr_rel=1;
		else $this->size_addr_rel = ceil(log($count_param, 2));
	}
	
	function create_dot_file($node, $filename)
	{
		$content='';
		
		$content.='digraph G {'."\n";
		foreach($node->blocks as $block)
		{
			if($block->name!="fi" and $block->name!="bi" and $block->name!="ci" and $block->name!="ri")
			{
				$ins=array();
				$outs=array();
				foreach($block->flows as $flow)
				{
					if($flow->type=='in') array_push($ins, $flow);
					if($flow->type=='out') array_push($outs, $flow);
				}
				
				$content.="\t".$block->name.'[shape = record,label = "';
				$content.='{{';
				$count=0;
				foreach($ins as $in)
				{
					$content.='<'.$in->name.'> '.$in->name.' ('.$in->size.')';
					if(++$count<count($ins)) $content.='|';
				}
				$content.='}|'.$block->name.'|{';
				$count=0;
				foreach($outs as $out)
				{
					$content.='<'.$out->name.'> '.$out->name.' ('.$out->size.')';
					if(++$count<count($outs)) $content.='|';
				}
				
				$content.='}}"];'."\n";
			}
		}
	
		foreach($this->tree_connects as $in_connect => $out_connects)
		{
			foreach($out_connects as $key => $out_connect)
			{
				if(is_numeric($key))
				{
					$from=$out_connect['name'];
					$from_block=substr($from,0,strrpos($from,'_',-1));
					$from_flow=substr($from,strrpos($from,'_',-1)+1);
					$to=$in_connect;
					$to_block=substr($to,0,strrpos($to,'_',-1));
					$to_flow=substr($to,strrpos($to,'_',-1)+1);
					$content.="\t".'"'.$from_block.'":'.$from_flow.' -> "'.$to_block.'":'.$to_flow.';'."\n";
				}
			}
		}
		$content.='}'."\n";
	
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
			if (!$handle = fopen($filename, 'w')) error("$filename cannot be openned",5,"FI");
			if (fwrite($handle, $content) === FALSE) error("$filename cannot be written",5,"FI");
			fclose($handle);
		}
	}
	
	function generate($node, $block, $path, $language)
	{
		$generator = new VHDL_generator('fi');
	
		if(!$fi=$node->getBlock('fi')) return;
		$generator->fromBlock($fi);
	
		$code='';
	
		// create mux foreach input flow and reg
		$count_reg=0;
		foreach($fi->tree_connects as $in_connect => $out_connects)
		{
			if(count($out_connects)-2==0)
			{
				// nothing to do
			}
			elseif(count($out_connects)-2==1)
			{
				$in_size = $out_connects['size'];
				$out_size = $out_connects[0]['size'];
			
				if($in_size == $out_size)
				{
					$code.='	'.$in_connect.'_data <= '.$out_connects[0]['name'].'_data;'."\n";
				}
				elseif($in_size > $out_size)
				{
					$padding_size = $in_size - $out_size;
					$padding = '"' . str_pad('', $padding_size, '0') . '"';
					if($out_connect['order']=='msb')
					{
						$code.='	'.$in_connect.'_data <= '.$out_connects[0]['name'].'_data & '.$padding.';'."\n";
					}
					else
					{
						$code.='	'.$in_connect.'_data <= '.$padding.' & '.$out_connects[0]['name'].'_data;'."\n";
					}
				}
				elseif($in_size < $out_size)
				{
					$padding_size = $out_size - $in_size;
					if($out_connect['order']=='msb')
					{
						$code.='	'.$in_connect.'_data <= '.$out_connects[0]['name'].'_data('.($out_size-1).' downto '.$padding_size.');'."\n";
					}
					else
					{
						$code.='	'.$in_connect.'_data <= '.$out_connects[0]['name'].'_data('.($padding_size-1).' downto 0);'."\n";
					}
					warning("Size of flow ".$out_connects[0]['name']." ($out_size) > size of flow ".$in_connect." ($in_size), ".$out_connects[0]['order']." connection",10,"FI");
				}
				$code.='	'.$in_connect.'_fv <=  '.$out_connects[0]['name'].'_fv;'."\n";
				$code.='	'.$in_connect.'_dv <=  '.$out_connects[0]['name'].'_dv;'."\n"."\n";
			}
			else
			{
				$name_reg = 'mux_'.$in_connect.'_reg';
				$generator->addSignal($name_reg, 32, 'std_logic_vector');
			
				$code.='	mux_'.$in_connect.' : process (clk_proc, reset)'."\n";
				$code.='	begin'."\n";
				$code.='		if(reset=\'0\') then'."\n";
				$code.='			'.$in_connect.'_data <= (others => \'0\');'."\n";
				$code.='			'.$in_connect.'_fv <= \'0\';'."\n";
				$code.='			'.$in_connect.'_dv <= \'0\';'."\n";
			
				$code.='		elsif(rising_edge(clk_proc)) then'."\n";
				$code.='			case '.$name_reg.' is'."\n";
			
				$value_mux=0;
				foreach($out_connects as $key => $out_connect)
				{
					if(is_numeric($key))
					{
						$code.='				when std_logic_vector(to_unsigned('.$value_mux.', 32))=>'."\n";
					
						$in_size = $out_connects['size'];
						$out_size = $out_connect['size'];
			
						if($in_size == $out_size)
						{
							$code.='					'.$in_connect.'_data <= '.$out_connect['name'].'_data;'."\n";
						}
						elseif($in_size > $out_size)
						{
							$padding_size = $in_size - $out_size;
							$padding = '"' . str_pad('', $padding_size, '0') . '"';
							if($out_connect['order']=='msb')
							{
								$code.='					'.$in_connect.'_data <= '.$out_connect['name'].'_data & '.$padding.';'."\n";
							}
							else
							{
								$code.='					'.$in_connect.'_data <= '.$padding.' & '.$out_connect['name'].'_data;'."\n";
							}
						}
						elseif($in_size < $out_size)
						{
							$padding_size = $out_size - $in_size;
							if($out_connect['order']=='msb')
							{
								$code.='					'.$in_connect.'_data <= '.$out_connect['name'].'_data('.($out_size-1).' downto '.$padding_size.');'."\n";
							}
							else
							{
								$code.='					'.$in_connect.'_data <= '.$out_connect['name'].'_data('.($padding_size-1).' downto 0);'."\n";
							}
							warning("Size of flow ".$out_connect['name']." ($out_size) > ".$in_connect." ($in_size), ".$out_connect['order']." connection",10,"FI");
						}
					
						$code.='					'.$in_connect.'_fv <= '.$out_connect['name'].'_fv;'."\n";
						$code.='					'.$in_connect.'_dv <= '.$out_connect['name'].'_dv;'."\n";
						$value_mux++;
					}
				}
				$code.='				when others=>'."\n";
				$code.='					'.$in_connect.'_data <= (others => \'0\');'."\n";
				$code.='					'.$in_connect.'_fv <= \'0\';'."\n";
				$code.='					'.$in_connect.'_dv <= \'0\';'."\n";
				$code.='			end case;'."\n";
				$code.='		end if;'."\n";
				$code.='	end process;'."\n";
				$code.="\n";
			}
		}
	
		$count_reg=0;
		foreach($fi->tree_connects as $in_connect => $out_connects)
		{
			if(count($out_connects)-2>1)
			{
				$name_reg = 'mux_'.$in_connect.'_reg';
				$code.='	slave_'.$in_connect.' : process (clk_proc, reset)'."\n";
				$code.='	begin'."\n";
				$code.='		if(reset=\'0\') then'."\n";
				$code.='			'.$name_reg.' <= (others => \'0\');'."\n";	// TODO modify default value
			
				$code.='		elsif(rising_edge(clk_proc)) then'."\n";
				
				if($fi->size_addr_rel==1)
				{
					$code.='			if(wr_i=\'1\' and addr_rel_i=\''.$count_reg.'\') then'."\n";
				}
				else
				{
					$code.='			if(wr_i=\'1\' and addr_rel_i=std_logic_vector(to_unsigned('.$count_reg.', '.$fi->size_addr_rel.'))) then'."\n";
				}
				$code.='				'.$name_reg.' <= datawr_i;'."\n";
				$code.='			end if;'."\n";
				$code.='		end if;'."\n";
				$code.='	end process;'."\n";
				$code.="\n";
			
				$count_reg++;
			}
		}
	
		$generator->code=$code;
	
		$filename = $path.DIRECTORY_SEPARATOR.'flow_interconnect.vhd';
		$generator->save_as_ifdiff($filename);
	
		$file = new File();
		$file->name = 'flow_interconnect.vhd';
		$file->group = 'hdl';
		$file->type = 'vhdl';
		array_push($fi->files, $file);
		
		$this->create_dot_file($node, $path.DIRECTORY_SEPARATOR.'fi.dot');
	}
	
	public function type() {return 'fi';}
	
	public function getXmlElement($xml)
	{
		$xml_element = parent::getXmlElement($xml);
		
		// clock_providers
		$xml_flow_connects = $xml->createElement("flow_connects");
		foreach($this->flow_connects as $flow_connect)
		{
			$xml_flow_connects->appendChild($flow_connect->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_flow_connects);
		
		return $xml_element;
	}
	
	/** Add a flow connection to the block 
	 *  @param FlowConnect $flow_connect flow connection to add to the block **/
	function addFlowConnect($flow_connect)
	{
		$flow_connect->parentBlock = $this;
		array_push($this->flow_connects, $flow_connect);
	}
	
	/** return a reference to the flow connection with the name $name, if not found, return false
	 *  @param string $name name of the flow connection to search
	 *  @return FlowConnect found flow connection **/
	function getFlowConnect($name)
	{
		foreach($this->flow_connects as $flow_connect)
		{
			if($flow_connect->name==$name) return $flow_connect;
		}
		return null;
	}
}

?>
