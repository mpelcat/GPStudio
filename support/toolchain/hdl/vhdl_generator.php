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
	
	public $declare;
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
			$this->addPort($clock->name, 1, $clock->direction);
			
			if($clock->direction=="in")
			{
				$this->addGeneric(strtoupper($clock->name).'_FREQ', $clock->typical);
			}
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
				$this->addPort($flow->name . '_data', strtoupper($flow->name).'_SIZE', $flow->type);
				$this->addPort($flow->name . '_fv', 1, $flow->type);
				$this->addPort($flow->name . '_dv', 1, $flow->type);
				
				$this->addGeneric(strtoupper($flow->name).'_SIZE', $flow->size);
			}
			elseif($flow->type=='in_conn' or $flow->type=='out_conn')
			{
				if($flow->type=='in_conn') $direction='out'; else $direction='in';
				$this->addPortComment(str_pad(' '.$flow->name.' ',55,'-',STR_PAD_BOTH));
				$this->addPort($flow->name . '_data', strtoupper($flow->name).'_SIZE', $direction);
				$this->addPort($flow->name . '_fv', 1, $direction);
				$this->addPort($flow->name . '_dv', 1, $direction);
				
				$this->addGeneric(strtoupper($flow->name).'_SIZE', $flow->size);
			}
		}
		//interfaces
		$mastercount=0;
		foreach($block->interfaces as $interface)
		{
			if($interface->type=='pi_master')
			{
				if($mastercount++==0) $this->addPortComment(str_pad(' Masters ',55,'=',STR_PAD_BOTH));
				$this->addPortComment(str_pad(' '.$interface->name.' ',55,'-',STR_PAD_BOTH));

				$this->addPort('master_addr_o', $interface->size_addr, 'out');
				$this->addPort('master_wr_o', 1, 'out');
				$this->addPort('master_rd_o', 1, 'out');
				$this->addPort('master_datawr_o', 32, 'out');
				$this->addPort('master_datard_i', 32, 'in');
			}
			if($interface->type=='pi_master_conn')
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
			if($interface->type=='pi_slave')
			{
				if($slavecount++==0) $this->addPortComment(str_pad(' Slaves ',55,'=',STR_PAD_BOTH));
				$this->addPortComment(str_pad(' '.$interface->name.' ',55,'-',STR_PAD_BOTH));

				$this->addPort('addr_rel_i', $interface->size_addr, 'in');
				$this->addPort('wr_i', 1, 'in');
				$this->addPort('rd_i', 1, 'in');
				$this->addPort('datawr_i', 32, 'in');
				$this->addPort('datard_o', 32, 'out');
			}
			if($interface->type=='pi_slave_conn')
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
		$maxLenght=0;
		foreach($this->params as $param)
		{
			if(strlen($param->name)>$maxLenght) $maxLenght=strlen($param->name);
		}
		if(!empty($this->params))
		{
			$content.='	generic ('."\r\n";
			$i=0;
			$len = count($this->params);
			foreach($this->params as $param)
			{
				$i++;
				$content.='		'.str_pad($param->name,$maxLenght,' ').' : '.$param->type;
				if($i<$len) $content.=";\r\n";
			}
			$content.="\r\n";
			$content.='	);'."\r\n";
		}
		
		// port declaration
		$content.='	port ('."\r\n";
		$i=0;
		$len = count($this->ports);
		$maxLenght=0;
		foreach($this->ports as $port)
		{
			if(!$port->space)
			{
				if(strlen($port->name)>$maxLenght) $maxLenght=strlen($port->name);
			}
		}
		foreach($this->ports as $port)
		{
			$i++;
			if($port->space)
			{
				$content.="\r\n".'		--'.$port->name."\r\n";
			}
			else
			{
				if($port->size==1 and $port->default!='std_logic_vector')
				{
					$content.='		'.str_pad($port->name,$maxLenght,' ').' : '.$port->type.' std_logic';
				}
				else
				{
					if(is_numeric($port->size))
					{
						$content.='		'.str_pad($port->name,$maxLenght,' ').' : '.$port->type.' std_logic_vector('.($port->size-1).' downto 0)';
					}
					else
					{
						$content.='		'.str_pad($port->name,$maxLenght,' ').' : '.$port->type.' std_logic_vector('.$port->size.'-1 downto 0)';
					}
				}
				if($i<$len) $content.=";\r\n";
			}
		}
		$content.="\r\n";
		$content.='	);'."\r\n";
		return $content;
	}
	
	function get_content()
	{
		$content = "";
		
		// ====== header and libs ======
		foreach($this->libs as $lib)
		{
			$content.=$lib."\r\n";
		}
		$content.="\r\n";
		
		// ========== entity ==========
		$content.='entity '.$this->name.' is'."\r\n";
		$content.=$this->get_ports_and_generic();
		$content.='end '.$this->name.';'."\r\n";
		$content.="\r\n";
		
		// ======= architecture =======
		$content.='architecture rtl of '.$this->name.' is'."\r\n";
		
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
			
					$content.='component '.$block->driver."\r\n";
					$content.=$modgenerator->get_ports_and_generic();
					$content.='end component;'."\r\n\r\n";
			
					unset($modgenerator);
					array_push($used_drivers, $block->driver);
				}
			}
		}
	
		// internal signal
		$maxLenght=0;
		foreach($this->signals as $signal)
		{
			if(!$signal->space)
			{
				if(strlen($signal->name)>$maxLenght) $maxLenght=strlen($signal->name);
			}
		}
		foreach($this->signals as $signal)
		{
			if($signal->space)
			{
				$content.="\r\n".'	--'.str_pad($signal->name,$maxLenght,' ')."\r\n";
			}
			else
			{
				if($signal->size==1 and $signal->type!='std_logic_vector')
				{
					$content.='	signal '.str_pad($signal->name,$maxLenght,' ').' : '.$signal->type.';'."\r\n";
				}
				else
				{
					$content.='	signal '.str_pad($signal->name,$maxLenght,' ').' : '.$signal->type.' ('.($signal->size-1).' downto 0);'."\r\n";
				}
			}
		}
		
		if(!empty($this->declare)) $content.="\r\n".$this->declare;
		
		$content.="\r\n";
	
		$content.='begin'."\r\n";
		
		if(!empty($this->blocks))
		{
			foreach($this->blocks as $block)
			{
			// generic map
				$name = $block->name;
				if($name==$block->driver) $name=$name.'_inst';
				$content.='	'.$name.' : '.$block->driver."\r\n";
				
				$genericmap = array();
				foreach($block->clocks as $clock)
				{
					if($clock->direction=="in")
					{
						array_push($genericmap, array(strtoupper($clock->name).'_FREQ', $clock->typical));
					}
				}
				foreach($block->params as $param)
				{
					if($param->hard)
					{
						array_push($genericmap, array($param->name, $param->value));
					}
				}
				foreach($block->flows as $flow)
				{
					array_push($genericmap, array(strtoupper($flow->name).'_SIZE', $flow->size));
				}
				
				$first=true;
				$maxLenght=0;
				foreach($genericmap as $map)
				{
					if(strlen($map[0])>$maxLenght) $maxLenght=strlen($map[0]);
				}
				foreach($genericmap as $map)
				{
					if(!$first) $content.=','."\r\n"; else { $first=false; $content.='    generic map ('."\r\n"; }
					$content.='		'.str_pad($map[0],$maxLenght,' ').' => '.$map[1];
				}
				if(!$first) $content.="\r\n".'	)'."\r\n";
				
			// port map
				$portmap = array();
				// clocks mapping
				foreach($block->clocks as $clock)
				{
					array_push($portmap, array($clock->name, $clock->net));
				}
				// resets mapping
				foreach($block->resets as $reset)
				{
					array_push($portmap, array($reset->name, $reset->group));
				}
				// ext ports mapping
				foreach($block->ext_ports as $port)
				{
					array_push($portmap, array($port->name, $block->name.'_'.$port->name));
				}
				// flows mapping
				foreach($block->flows as $flow)
				{
					if($flow->type=='in' or $flow->type=='out')
					{
						array_push($portmap, array($flow->name . '_data', $block->name . '_' . $flow->name . '_data_s'));
						array_push($portmap, array($flow->name . '_fv', $block->name . '_' . $flow->name . '_fv_s'));
						array_push($portmap, array($flow->name . '_dv', $block->name . '_' . $flow->name . '_dv_s'));
					}
					else
					{
						array_push($portmap, array($flow->name . '_data', $flow->name . '_data_s'));
						array_push($portmap, array($flow->name . '_fv', $flow->name . '_fv_s'));
						array_push($portmap, array($flow->name . '_dv', $flow->name . '_dv_s'));
					}
				}
				// bus mapping
				foreach($block->interfaces as $interface)
				{
					if($interface->type=='pi_slave')
					{
						array_push($portmap, array('addr_rel_i', $block->name.'_addr_rel_s'));
						array_push($portmap, array('wr_i', $block->name.'_wr_s'));
						array_push($portmap, array('rd_i', $block->name.'_rd_s'));
						array_push($portmap, array('datawr_i', $block->name.'_datawr_s'));
						array_push($portmap, array('datard_o', $block->name.'_datard_s'));
					}
					if($interface->type=='pi_master')
					{
						array_push($portmap, array('master_addr_o', $block->name.'_master_addr_s'));
						array_push($portmap, array('master_wr_o', $block->name.'_master_wr_s'));
						array_push($portmap, array('master_rd_o', $block->name.'_master_rd_s'));
						array_push($portmap, array('master_datawr_o', $block->name.'_master_datawr_s'));
						array_push($portmap, array('master_datard_i', $block->name.'_master_datard_s'));
					}
					if($interface->type=='pi_slave_conn')
					{
						array_push($portmap, array($interface->blockname.'_addr_rel_o', $interface->blockname.'_addr_rel_s'));
						array_push($portmap, array($interface->blockname.'_wr_o', $interface->blockname.'_wr_s'));
						array_push($portmap, array($interface->blockname.'_rd_o', $interface->blockname.'_rd_s'));
						array_push($portmap, array($interface->blockname.'_datawr_o', $interface->blockname.'_datawr_s'));
						array_push($portmap, array($interface->blockname.'_datard_i', $interface->blockname.'_datard_s'));
					}
					if($interface->type=='pi_master_conn')
					{
						array_push($portmap, array($interface->blockname.'_master_addr_i', $interface->blockname.'_master_addr_s'));
						array_push($portmap, array($interface->blockname.'_master_wr_i', $interface->blockname.'_master_wr_s'));
						array_push($portmap, array($interface->blockname.'_master_rd_i', $interface->blockname.'_master_rd_s'));
						array_push($portmap, array($interface->blockname.'_master_datawr_i', $interface->blockname.'_master_datawr_s'));
						array_push($portmap, array($interface->blockname.'_master_datard_o', $interface->blockname.'_master_datard_s'));
					}
				}
				
				$first=true;
				$maxLenght=0;
				$content.='    port map ('."\r\n";
				foreach($portmap as $map)
				{
					if(strlen($map[0])>$maxLenght) $maxLenght=strlen($map[0]);
				}
				foreach($portmap as $map)
				{
					if(!$first) $content.=','."\r\n"; else $first=false;
					$content.='		'.str_pad($map[0],$maxLenght,' ').' => '.$map[1];
				}
				$content.="\r\n".'	);'."\r\n";
				
				$content.="\r\n";
			}
		}
		
		$content.=$this->code."\r\n";
		$content.='end rtl;'."\r\n";
		
		return $content;
	}
	
	function save_as($filename)
	{
		$handle = null;
		if (!$handle = fopen($filename, 'w')) error("$filename cannot be openned",5,"Vhdl Gen");
		if (fwrite($handle, $this->get_content()) === FALSE) error("$filename cannot be written",5,"Vhdl Gen");
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
			if (!$handle = fopen($filename, 'w')) error("$filename cannot be openned",5,"Vhdl Gen");
			if (fwrite($handle, $this->get_content()) === FALSE) error("$filename cannot be written",5,"Vhdl Gen");
			fclose($handle);
		}
	}
}

?>
