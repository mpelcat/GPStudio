<?php

require_once("file.php");
require_once("param.php");
require_once("flow.php");
require_once("clock.php");
require_once("reset.php");
require_once("pin.php");
require_once("port.php");
require_once("interface.php");

class Block
{
	public $name;
	public $path;
	public $in_lib;
	
	public $addr_abs;
	public $size_addr_rel;
	public $master_count;

	public $params;
	public $files;
	public $flows;
	public $clocks;
	public $resets;
	public $driver;
	public $pins;
	public $ext_ports;
	public $interfaces;
	
	protected $xml;
	
	function __construct()
	{
		$this->params = array();
		$this->files = array();
		$this->flows = array();
		$this->clocks = array();
		$this->resets = array();
		$this->pins = array();
		$this->ext_ports = array();
		$this->interfaces = array();
		$this->addr_abs = -1;
		$this->master_count = 0;
		
		$this->in_lib=false;
		
		$clock = new Clock();
		$clock->name='clk_proc';
		$clock->group='clk_proc';
		array_push($this->clocks, $clock);
		
		/*$reset = new Reset();
		$reset->name='reset';
		$reset->group='reset';
		array_push($this->resets, $reset);*/
	}
	
	function getFlow($name)
	{
		foreach($this->flows as $flow)
		{
			if($flow->name==$name) return $flow;
		}
		return null;
	}
	
	protected function parse_xml()
	{
		$this->size_addr_rel = (int)$this->xml['size_addr_rel'];
		// files
		if(isset($this->xml->files))
		{
			foreach($this->xml->files->file as $file)
			{
				array_push($this->files, new File($file));
			}
		}
		
		// params
		if(isset($this->xml->params))
		{
			foreach($this->xml->params->param as $param)
			{
				array_push($this->params, new Param($param));
			}
		}
		
		// flows
		if(isset($this->xml->flows))
		{
			foreach($this->xml->flows->flow as $flow)
			{
				array_push($this->flows, new Flow($flow));
			}
		}
		
		// clocks
		if(isset($this->xml->clocks))
		{
			foreach($this->xml->clocks->clock as $clock)
			{
				array_push($this->clocks, new Clock($clock));
			}
		}
		
		// resets
		if(isset($this->xml->resets))
		{
			foreach($this->xml->resets->reset as $reset)
			{
				array_push($this->resets, new Reset($reset));
			}
		}
	}
}

?>
