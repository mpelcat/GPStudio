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
	
	function configure($node, $block)
	{
		// nothing to do for global block
	}
	
	function generate($node, $block, $path, $language)
	{
		// nothing to do for global block
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
	
	public function getXmlElement($xml)
	{
		$xml_element = $xml->createElement("block");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// type
		$att = $xml->createAttribute('type');
		$att->value = $this->type();
		$xml_element->appendChild($att);
		
		// in_lib
		$att = $xml->createAttribute('in_lib');
		$att->value = $this->in_lib;
		$xml_element->appendChild($att);
		
		// addr_abs
		$att = $xml->createAttribute('addr_abs');
		$att->value = $this->addr_abs;
		$xml_element->appendChild($att);
		
		// size_addr_rel
		$att = $xml->createAttribute('size_addr_rel');
		$att->value = $this->size_addr_rel;
		$xml_element->appendChild($att);
		
		// master_count
		$att = $xml->createAttribute('master_count');
		$att->value = $this->master_count;
		$xml_element->appendChild($att);
		
		// files
		$xml_files = $xml->createElement("files");
		foreach($this->files as $file)
		{
			$xml_files->appendChild($file->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_files);
		
		// params
		$xml_params = $xml->createElement("params");
		foreach($this->params as $param)
		{
			$xml_params->appendChild($param->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_params);
		
		// flows
		$xml_flows = $xml->createElement("flows");
		foreach($this->flows as $flow)
		{
			if($flow->type=="in" or $flow->type=="out")
			{
				$xml_flows->appendChild($flow->getXmlElement($xml));
			}
		}
		$xml_element->appendChild($xml_flows);
		
		// clocks
		$xml_clocks = $xml->createElement("clocks");
		foreach($this->clocks as $clock)
		{
			$xml_clocks->appendChild($clock->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_clocks);
		
		// resets
		$xml_resets = $xml->createElement("resets");
		foreach($this->resets as $reset)
		{
			$xml_resets->appendChild($reset->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_resets);
		
		return $xml_element;
	}
}

?>
