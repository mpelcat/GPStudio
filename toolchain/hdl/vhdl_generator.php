<?php

require_once("block.php");

class Module_param
{
	public $name;
	public $size;
	public $type;
	public $default;
	public $space;
	
	function __construct($name='', $size=1, $type='', $default='', $space=false)
	{
		$this->name = $name;
		$this->size = $size;
		$this->type = $type;
		$this->default = $default;
		$this->space = $space;
	}
}

class VHDL_generator
{
	public $name;
	
	public $libs;
	public $signals;
	public $ports;
	public $params;
	public $blocks;
	
	public $code;
	
	function __construct($name='module')
	{
		$this->name=$name;
		
		$this->libs=array("library IEEE;","use IEEE.STD_LOGIC_1164.all;","use IEEE.NUMERIC_STD.all;","library std;");
		$this->signals=array();
		$this->ports=array();
		$this->params=array();
		$this->blocks=array();
	}
	
	function fromBlock($block)
	{
		// generic
		foreach($block->params as $param)
		{
			if($param->hard)
			{
				$this->addGeneric($param->name, $param->value);
			}
		}
		// clocks
		foreach($block->clocks as $clock)
		{
			$this->addPort($clock->name, 1, 'in');
		}
		// resets
		foreach($block->resets as $reset)
		{
			$this->addPort($reset->name, 1, $reset->direction);
		}
		// external ports
		if(!empty($block->ext_ports))
		{
			$this->addPortComment(str_pad(' external ports ',55,'-',STR_PAD_BOTH));
			foreach($block->ext_ports as $port)
			{
				$this->addPort($port->name, $port->size, $port->type);
			}
		}
		// flows
		foreach($block->flows as $flow)
		{
			if($flow->type=='in' or $flow->type=='out')
			{
				$this->addPortComment(str_pad(' '.$flow->name.' flow ',55,'-',STR_PAD_BOTH));
				$this->addPort($flow->name . '_data', $flow->size, $flow->type);
				$this->addPort($flow->name . '_fv', 1, $flow->type);
				$this->addPort($flow->name . '_dv', 1, $flow->type);
			}
			elseif($flow->type=='in_conn' or $flow->type=='out_conn')
			{
				if($flow->type=='in_conn') $direction='out'; else $direction='in';
				$this->addPortComment(str_pad(' '.$flow->name.' ',55,'-',STR_PAD_BOTH));
				$this->addPort($flow->name . '_data', $flow->size, $direction);
				$this->addPort($flow->name . '_fv', 1, $direction);
				$this->addPort($flow->name . '_dv', 1, $direction);
			}
		}
		//interfaces
		$mastercount=0;
		foreach($block->interfaces as $interface)
		{
			if($interface->type=='bi_master')
			{
				if($mastercount++==0) $this->addPortComment(str_pad(' Masters ',55,'=',STR_PAD_BOTH));
				$this->addPortComment(str_pad(' '.$interface->name.' ',55,'-',STR_PAD_BOTH));

				$this->addPort('master_addr_o', $interface->size_addr, 'out');
				$this->addPort('master_wr_o', 1, 'out');
				$this->addPort('master_rd_o', 1, 'out');
				$this->addPort('master_datawr_o', 32, 'out');
				$this->addPort('master_datard_i', 32, 'in');
			}
			if($interface->type=='bi_master_conn')
			{
				if($mastercount++==0) $this->addPortComment(str_pad(' Masters ',55,'=',STR_PAD_BOTH));
				$this->addPortComment(str_pad(' '.$interface->name.' ',55,'-',STR_PAD_BOTH));

				$this->addPort($interface->blockname.'_master_addr_i', $interface->size_addr, 'in');
				$this->addPort($interface->blockname.'_master_wr_i', 1, 'in');
				$this->addPort($interface->blockname.'_master_rd_i', 1, 'in');
				$this->addPort($interface->blockname.'_master_datawr_i', 32, 'in');
				$this->addPort($interface->blockname.'_master_datard_o', 32, 'out');
			}
		}
		$slavecount=0;
		foreach($block->interfaces as $interface)
		{
			if($interface->type=='bi_slave')
			{
				if($slavecount++==0) $this->addPortComment(str_pad(' Slaves ',55,'=',STR_PAD_BOTH));
				$this->addPortComment(str_pad(' '.$interface->name.' ',55,'-',STR_PAD_BOTH));

				$this->addPort('addr_rel_i', $interface->size_addr, 'in');
				$this->addPort('wr_i', 1, 'in');
				$this->addPort('rd_i', 1, 'in');
				$this->addPort('datawr_i', 32, 'in');
				$this->addPort('datard_o', 32, 'out');
			}
			if($interface->type=='bi_slave_conn')
			{
				if($slavecount++==0) $this->addPortComment(str_pad(' Slaves ',55,'=',STR_PAD_BOTH));
				$this->addPortComment(str_pad(' '.$interface->name.' ',55,'-',STR_PAD_BOTH));

				$this->addPort($interface->blockname.'_addr_rel_o', $interface->size_addr, 'out');
				$this->addPort($interface->blockname.'_wr_o', 1, 'out');
				$this->addPort($interface->blockname.'_rd_o', 1, 'out');
				$this->addPort($interface->blockname.'_datawr_o', 32, 'out');
				$this->addPort($interface->blockname.'_datard_i', 32, 'in');
				$this->addSignal('cs_'.$interface->blockname.'_s', 1, 'std_logic');
			}
		}
	}
	
	function addPort($name, $size, $direction, $type='')
	{
		if($type=='' and $size>1) $type='std_logic_vector';
		array_push($this->ports, new Module_param($name, $size, $direction, $type));
	}
	
	function addPortComment($comment)
	{
		array_push($this->ports, new Module_param($comment, 0, '', '', true));
	}
	
	function addSignal($name, $size, $type)
	{
		array_push($this->signals, new Module_param($name, $size, $type));
	}
	
	function addSignalComment($comment)
	{
		array_push($this->signals, new Module_param($comment, 0, '', '', true));
	}
	
	function addGeneric($name, $value)
	{
		array_push($this->params, new Module_param($name, '', 'integer', $value));
	}
	
	function addCode($code)
	{
		$this->code.=$code;
	}
	
	function get_ports_and_generic()
	{
		$content = '';
		
		// generic declaration
		if(!empty($this->params))
		{
			$content.='	generic ('."\n";
			$i=0;
			$len = count($this->params);
			foreach($this->params as $param)
			{
				$i++;
				$content.='		'.$param->name.' : '.$param->type;
				if($i<$len) $content.=";\n";
			}
			$content.="\n";
			$content.='	);'."\n";
		}
		
		// port declaration
		$content.='	port ('."\n";
		$i=0;
		$len = count($this->ports);
		foreach($this->ports as $port)
		{
			$i++;
			if($port->space)
			{
				$content.="\n".'		--'.$port->name."\n";
			}
			else
			{
				if($port->size==1 and $port->default!='std_logic_vector')
				{
					$content.='		'.$port->name.' : '.$port->type.' std_logic';
				}
				else
				{
					$content.='		'.$port->name.' : '.$port->type.' std_logic_vector('.($port->size-1).' downto 0)';
				}
				if($i<$len) $content.=";\n";
			}
		}
		$content.="\n";
		$content.='	);'."\n";
		return $content;
	}
	
	function get_content()
	{
		$content = "";
		
		// ====== header and libs ======
		foreach($this->libs as $lib)
		{
			$content.=$lib."\n";
		}
		$content.="\n";
		
		// ========== entity ==========
		$content.='entity '.$this->name.' is'."\n";
		$content.=$this->get_ports_and_generic();
		$content.='end '.$this->name.';'."\n";
		$content.="\n";
		
		// ======= architecture =======
		$content.='architecture rtl of '.$this->name.' is'."\n";
		
		// components declaration
		$used_drivers = array();
		if(!empty($this->blocks))
		{
			foreach($this->blocks as $block)
			{
				if(!in_array($block->driver, $used_drivers))
				{
					$modgenerator = new VHDL_generator();
					$modgenerator->fromBlock($block);
			
					$content.='component '.$block->driver."\n";
					$content.=$modgenerator->get_ports_and_generic();
					$content.='end component;'."\n\n";
			
					unset($modgenerator);
					array_push($used_drivers, $block->driver);
				}
			}
		}
	
		// internal signal
		foreach($this->signals as $signal)
		{
			if($signal->space)
			{
				$content.="\n".'	--'.$signal->name."\n";
			}
			else
			{
				if($signal->size==1 and $signal->type!='std_logic_vector')
				{
					$content.='	signal '.$signal->name.' : '.$signal->type.';'."\n";
				}
				else
				{
					$content.='	signal '.$signal->name.' : '.$signal->type.' ('.($signal->size-1).' downto 0);'."\n";
				}
			}
		}
		$content.="\n";
	
		$content.='begin'."\n";
		
		if(!empty($this->blocks))
		{
			foreach($this->blocks as $block)
			{
			// generic map
				$first=true;
				
				$name = $block->name;
				if($name==$block->driver) $name=$name.'_inst';
				$content.='	'.$name.' : '.$block->driver."\n";
				
				foreach($block->params as $param)
				{
					if($param->hard)
					{
						if(!$first) $content.=','."\n"; else { $first=false; $content.='    generic map ('."\n"; }
						$content.='    	'.$param->name.'	=>	'.$param->value;
					}
				}
				if(!$first) $content.="\n".'	)'."\n";
				
			// port map
				$first=true;
				$content.='    port map ('."\n";
				// clocks mapping
				foreach($block->clocks as $clock)
				{
					if(!$first) $content.=','."\n"; else $first=false;
					$content.='    	'.$clock->name.'	=>	'.$clock->group;
				}
				// resets mapping
				foreach($block->resets as $reset)
				{
					if(!$first) $content.=','."\n"; else $first=false;
					$content.='    	'.$reset->name.'	=>	'.$reset->group;
				}
				// ext ports mapping
				foreach($block->ext_ports as $port)
				{
					if(!$first) $content.=','."\n"; else $first=false;
					$content.='    	'.$port->name.'	=>	'.$block->name.'_'.$port->name;
				}
				// flows mapping
				foreach($block->flows as $flow)
				{
					if(!$first) $content.=','."\n"; else $first=false;
					if($flow->type=='in' or $flow->type=='out')
					{
						$content.='    	'.$flow->name . '_data'.'	=>	'.$block->name . '_' . $flow->name . '_data_s'.",\n";
						$content.='    	'.$flow->name . '_fv'.'	=>	'.$block->name . '_' . $flow->name . '_fv_s'.",\n";
						$content.='    	'.$flow->name . '_dv'.'	=>	'.$block->name . '_' . $flow->name . '_dv_s';
					}
					else
					{
						$content.='    	'.$flow->name . '_data'.'	=>	'.$flow->name . '_data_s'.",\n";
						$content.='    	'.$flow->name . '_fv'.'	=>	'.$flow->name . '_fv_s'.",\n";
						$content.='    	'.$flow->name . '_dv'.'	=>	'.$flow->name . '_dv_s';
					}
				}
				// bus mapping
				foreach($block->interfaces as $interface)
				{
					if($interface->type=='bi_slave')
					{
						if(!$first) $content.=','."\n"; else $first=false;
						$content.='    	addr_rel_i'.'	=>	'.$block->name.'_addr_rel_s'.",\n";
						$content.='    	wr_i'.'	=>	'.$block->name.'_wr_s'.",\n";
						$content.='    	rd_i'.'	=>	'.$block->name.'_rd_s'.",\n";
						$content.='    	datawr_i'.'	=>	'.$block->name.'_datawr_s'.",\n";
						$content.='    	datard_o'.'	=>	'.$block->name.'_datard_s';
					}
					if($interface->type=='bi_master')
					{
						if(!$first) $content.=','."\n"; else $first=false;
						$content.='    	master_addr_o'.'	=>	'.$block->name.'_master_addr_s'.",\n";
						$content.='    	master_wr_o'.'	=>	'.$block->name.'_master_wr_s'.",\n";
						$content.='    	master_rd_o'.'	=>	'.$block->name.'_master_rd_s'.",\n";
						$content.='    	master_datawr_o'.'	=>	'.$block->name.'_master_datawr_s'.",\n";
						$content.='    	master_datard_i'.'	=>	'.$block->name.'_master_datard_s';
					}
					if($interface->type=='bi_slave_conn')
					{
						if(!$first) $content.=','."\n"; else $first=false;
						$content.='    	'.$interface->blockname.'_addr_rel_o'.'	=>	'.$interface->blockname.'_addr_rel_s'.",\n";
						$content.='    	'.$interface->blockname.'_wr_o'.'	=>	'.$interface->blockname.'_wr_s'.",\n";
						$content.='    	'.$interface->blockname.'_rd_o'.'	=>	'.$interface->blockname.'_rd_s'.",\n";
						$content.='    	'.$interface->blockname.'_datawr_o'.'	=>	'.$interface->blockname.'_datawr_s'.",\n";
						$content.='    	'.$interface->blockname.'_datard_i'.'	=>	'.$interface->blockname.'_datard_s';
					}
					if($interface->type=='bi_master_conn')
					{
						if(!$first) $content.=','."\n"; else $first=false;
						$content.='    	'.$interface->blockname.'_master_addr_i'.'	=>	'.$interface->blockname.'_master_addr_s'.",\n";
						$content.='    	'.$interface->blockname.'_master_wr_i'.'	=>	'.$interface->blockname.'_master_wr_s'.",\n";
						$content.='    	'.$interface->blockname.'_master_rd_i'.'	=>	'.$interface->blockname.'_master_rd_s'.",\n";
						$content.='    	'.$interface->blockname.'_master_datawr_i'.'	=>	'.$interface->blockname.'_master_datawr_s'.",\n";
						$content.='    	'.$interface->blockname.'_master_datard_o'.'	=>	'.$interface->blockname.'_master_datard_s';
					}
				}
				
				$content.="\n".'	);'."\n";
				
				$content.="\n";
			}
		}
		
		$content.=$this->code."\n";
		$content.='end rtl;'."\n";
		
		return $content;
	}
	
	function save_as($filename)
	{
		$handle = null;
		if (!$handle = fopen($filename, 'w')) {  echo "$filename cannot be openned\n"; exit; }
		if (fwrite($handle, $this->get_content()) === FALSE) { echo "$filename cannot be written\n"; exit; }
		fclose($handle);
	}
	
	function save_as_ifdiff($filename)
	{
		// save file if it's different
		$needToReplace = false;
		
		$content = $this->get_content();
		if(file_exists($filename))
		{
			$handle = fopen($filename, 'r');
			$actualContent = fread($handle, filesize($filename));
			fclose($handle);
			if($actualContent != $this->get_content()) $needToReplace = true;
		}
		else $needToReplace = true;
	
		if($needToReplace)
		{
			$handle = null;
			if (!$handle = fopen($filename, 'w')) {  echo "$filename cannot be openned\n"; exit; }
			if (fwrite($handle, $this->get_content()) === FALSE) { echo "$filename cannot be written\n"; exit; }
			fclose($handle);
		}
	}
}

?>
