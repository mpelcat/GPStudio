<?php

require_once("block.php");
require_once("vhdl_generator.php");

class Block_generator
{
	public $block;
	
	private $slave_block;
	private $process_block;
	
	public $slave_generator;
	public $block_generator;
	public $process_generator;
	
	function __construct($block=NULL)
	{
		$this->slave_block = NULL;
		$this->process_block = NULL;
		
		$this->block_generator = NULL;
		$this->slave_generator = NULL;
		$this->process_generator = NULL;
		
		if($block!=NULL) $this->fromBlock($block); else $block = NULL;
	}
	
	static function hex($value, $width)
	{
		return 'x"'.str_pad(strtoupper(dechex($value)),ceil($width/4.0),'0',STR_PAD_LEFT).'"';
	}
	
	function fromBlock($block)
	{
		// top block creation
		$this->block=$block;
		
		if($this->block==NULL) return;
		
		// slave block creation
		if($this->block->pi_size_addr_rel>0)
		{
			array_push($this->block->interfaces, new InterfaceBus("bus_sl",$this->block->name,"pi_slave",$this->block->pi_size_addr_rel));
			
			$this->slave_block = new IO();
			$this->slave_block->name = $this->block->name . '_slave';
			$this->slave_block->driver = $this->block->name . '_slave';
			$this->slave_block->clocks = array();
			$this->slave_block->interfaces = $this->block->interfaces;
		}
		
		// slave block creation
		$this->process_block = new IO();
		$this->process_block->name = $this->block->name . '_process';
		$this->process_block->driver = $this->block->name . '_process';
		$this->process_block->clocks = array();
		$this->process_block->flows = $this->block->flows;
		$this->process_block->params = $this->block->params;
		
		// clocks copy
		foreach($this->block->clocks as $clock)
		{
			$nclock = new Clock();
			$nclock->name = $clock->name;
			$nclock->net = $clock->name;
			$this->process_block->addClock($nclock);
			if($this->slave_block!=NULL) $this->slave_block->addClock($nclock);
		}
		
		// resets copy
		foreach($this->block->resets as $reset)
		{
			$nreset = new Clock();
			$nreset->name = $reset->name;
			$nreset->group = $reset->name;
			$this->process_block->addReset($nreset);
			if($this->slave_block!=NULL) $this->slave_block->addReset($nreset);
		}
		
		// registers
		if($this->slave_block!=NULL)
		{
			foreach($this->block->params as $param)
			{
				if($param->hard==false)
				{
					if(empty($param->parambitfields))
					{
						$size = 32;
						
						// port connexion
						$port_param_in = new Port();
						$port_param_in->name = $param->name;
						$port_param_in->type = "in";
						$port_param_in->size = $size;
						$this->process_block->addExtPort($port_param_in);
						
						$port_param_out = new Port();
						$port_param_out->name = $param->name;
						$port_param_out->type = "out";
						$port_param_out->size = $size;
						$this->slave_block->addExtPort($port_param_out);
					}
					else
					{
						foreach($param->parambitfields as $parambitfields)
						{
							$size = count($parambitfields->bitfieldlist);
							
							if($size>0)
							{
								// port connexion
								$port_param_in = new Port();
								$port_param_in->name = $param->name.'_'.$parambitfields->name;
								$port_param_in->type = "in";
								$port_param_in->size = $size;
								$this->process_block->addExtPort($port_param_in);
								
								$port_param_out = new Port();
								$port_param_out->name = $param->name.'_'.$parambitfields->name;
								$port_param_out->type = "out";
								$port_param_out->size = $size;
								$this->slave_block->addExtPort($port_param_out);
							}
						}
					}
				}
			}
		}
	}
	
	public function generateTopBlock($path)
	{
		if($this->block==NULL) return;
		
		$this->block_generator = new VHDL_generator($this->block->name);
		
		// connexions between slave and process
		if($this->slave_block!=NULL)
		{
			foreach($this->block->params as $param)
			{
				if($param->hard==false)
				{
					if(empty($param->parambitfields))
					{
						$this->block_generator->addSignal($param->name, 32, 'std_logic_vector');
					}
					else
					{
						foreach($param->parambitfields as $parambitfields)
						{
							$size = count($parambitfields->bitfieldlist);
							
							if($size==1) $type="std_logic"; else $type="std_logic_vector";
							if($size>0) $this->block_generator->addSignal($param->name.'_'.$parambitfields->name, $size, $type);
						}
					}
				}
			}
		}
		
		// block top level generation
		$this->block_generator->fromBlock($this->block);
		$this->block_generator->addblock($this->process_block, TRUE);
		if($this->slave_block!=NULL) $this->block_generator->addblock($this->slave_block, TRUE);
		$this->block_generator->save_as_ifdiff($path.DIRECTORY_SEPARATOR.$this->block_generator->name.'.vhd');
	}
	
	public function generateProcess($path)
	{
		if($this->block==NULL) return;
		
		$this->process_generator = new VHDL_generator($this->block->name.'_process');
		
		// process generation
		$this->process_generator->fromBlock($this->process_block, TRUE);
		$this->process_generator->save_as_ifdiff($path.DIRECTORY_SEPARATOR.$this->process_generator->name.'.vhd');
	}
	
	public function generateSlave($path)
	{
		if($this->slave_block==NULL) return;
		
		$this->slave_generator = new VHDL_generator($this->block->name.'_slave');
		
		// registers
		usort($this->block->params, "Param::cmp_raddr");
		
		$this->slave_generator->addSignalComment(" Internal registers");
		$this->slave_generator->addConstantComment(" Registers address");
		
		$code_rst="";
		foreach($this->block->params as $param)
		{
			if($param->hard==false)
			{
				if($param->regaddr!='') $regaddr=$param->regaddr; else $regaddr=0;
				$this->slave_generator->addConstant(strtoupper($param->name)."_REG_ADDR", "natural", $regaddr);
				
				if(empty($param->parambitfields))
				{
					$size = 32;
					
					// slave internal
					$this->slave_generator->addSignal($param->name."_reg", $size, 'std_logic_vector');
					$code_rst.="			".$param->name."_reg <= ".Block_generator::hex($param->value,$size).";"."\r\n";
				}
				else
				{
					foreach($param->parambitfields as $parambitfield)
					{
						$size = count($parambitfield->bitfieldlist);
						
						if($size>0)
						{
							if($size==1) $type="std_logic"; else $type="std_logic_vector";
							
							// slave internal
							$this->slave_generator->addSignal($param->name."_".$parambitfield->name."_reg", $size, $type);
						}
					}
				}
			}
		}
		
		$size_master = $this->block->pi_size_addr_rel;
		
		// write reg code
		$code_wr="";
		$code_wr.="	write_reg : process (clk_proc, reset_n)"."\r\n";
		$code_wr.="	begin"."\r\n";
		$code_wr.="		if(reset_n='0') then"."\r\n";
		$code_wr.=$code_rst;
		$code_wr.="		elsif(rising_edge(clk_proc)) then"."\r\n";
		$code_wr.="			if(wr_i='1') then"."\r\n";
		$code_wr.="				case addr_rel_i is"."\r\n";
		foreach($this->block->params as $param)
		{
			if($param->hard==false)
			{
				$contant_reg_addr = strtoupper($param->name)."_REG_ADDR";
				$code_wr.="					when std_logic_vector(to_unsigned(".$contant_reg_addr.", ".$size_master."))=>"."\r\n";
				
				if(empty($param->parambitfields))
				{
					$size = 32;
					$reg_name = $param->name."_reg";
					$code_wr.="						".$reg_name." <= datawr_i;"."\r\n";
				}
				else
				{
					foreach($param->parambitfields as $parambitfield)
					{
						$size = count($parambitfield->bitfieldlist);
						
						if($size>0)
						{
							$bf_name = $param->name."_".$parambitfield->name."_reg";
							
							$code_wr.="						".$bf_name." <= ";
							$count=0;
							foreach($parambitfield->bitfieldlist as $bit)
							{
								if($count>0) $code_wr.=" & ";
								$code_wr.="datawr_i(".$bit.")";
								$count++;
							}
							$code_wr.=";"."\r\n";
						}
					}
				}
			}
		}
		
		$code_wr.="					when others=>"."\r\n";
		$code_wr.="				end case;"."\r\n";
		$code_wr.="			end if;"."\r\n";
		$code_wr.="		end if;"."\r\n";
		$code_wr.="	end process;"."\r\n";
		$code_wr.=""."\r\n";
		
		// read reg code
		$code_rd="";
		$code_rd.="	read_reg : process (clk_proc, reset_n)"."\r\n";
		$code_rd.="	begin"."\r\n";
		$code_rd.="		if(reset_n='0') then"."\r\n";
		$code_rd.="			datard_o <= (others => '0');"."\r\n";
		$code_rd.="		elsif(rising_edge(clk_proc)) then"."\r\n";
		$code_rd.="			if(rd_i='1') then"."\r\n";
		$code_rd.="				case addr_rel_i is"."\r\n";
		foreach($this->block->params as $param)
		{
			if($param->hard==false)
			{
				$contant_reg_addr = strtoupper($param->name)."_REG_ADDR";
				$code_rd.="					when std_logic_vector(to_unsigned(".$contant_reg_addr.", ".$size_master."))=>"."\r\n";
				
				if(empty($param->parambitfields))
				{
					$size = 32;
					
					$reg_name = $param->name."_reg";
					
					$code_rd.="						datard_o <= ".$reg_name.";"."\r\n";
				}
				else
				{
					$bits=array();
					foreach($param->parambitfields as $parambitfield)
					{
						$size = count($parambitfield->bitfieldlist);
						
						$bf_name = $param->name."_".$parambitfield->name."_reg";
						
						$count=$size;
						foreach($parambitfield->bitfieldlist as $bit)
						{
							$bits[$bit]=$bf_name."(".($count-1).")";
							$count--;
						}
					}
					
					$code_rd.="						datard_o <= ";
					$prev=31;
					$count=0;
					ksort($bits);
					$bits=array_reverse($bits,true);
					foreach($bits as $bitpos => $bitname)
					{
						if($count>0) $code_rd.=" & ";
						if($bitpos<$prev-1) $code_rd.="\"".str_repeat('0',$prev-$bitpos-1)."\" & ";
						$code_rd.=$bitname;
						$prev = $bitpos;
						$count++;
					}
					$code_rd.=";"."\r\n";
				}
			}
		}
		
		
		$code_rd.="					when others=>"."\r\n";
		$code_rd.="						datard_o <= (others => '0');"."\r\n";
		$code_rd.="				end case;"."\r\n";
		$code_rd.="			end if;"."\r\n";
		$code_rd.="		end if;"."\r\n";
		$code_rd.="	end process;"."\r\n";
		$code_rd.=""."\r\n";
		
		// output connexions
		$code_connect='';
		foreach($this->block->params as $param)
		{
			if($param->hard==false)
			{
				if(empty($param->parambitfields))
				{
					$reg_name = $param->name."_reg";
					$code_connect.="	$param->name <= $reg_name;"."\r\n";
				}
				else
				{
					foreach($param->parambitfields as $parambitfield)
					{
						$size = count($parambitfield->bitfieldlist);
						
						if($size>0)
						{
							$bf_name = $param->name."_".$parambitfield->name;
							
							$code_connect.="	".$bf_name." <= ".$bf_name."_reg;"."\r\n";
						}
					}
				}
			}
		}
		
		$this->slave_generator->addCode($code_wr);
		$this->slave_generator->addCode($code_rd);
		$this->slave_generator->addCode($code_connect);
		
		// slave generation
		$this->slave_generator->fromBlock($this->slave_block, TRUE);
		$this->slave_generator->save_as_ifdiff($path.DIRECTORY_SEPARATOR.$this->slave_generator->name.'.vhd');
	}
}

?>
