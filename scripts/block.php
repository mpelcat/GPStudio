<?php

require_once("file.php");
require_once("param.php");
require_once("property.php");
require_once("flow.php");
require_once("clock.php");
require_once("reset.php");
require_once("pin.php");
require_once("port.php");
require_once("interface.php");

class Block
{
	/**
	* Name of the block
	* @var string $name
	*/
	public $name;

	/**
	* Path where the root of files and define of the block is putted
	* @var string $path
	*/
	public $path;

	/**
	* Specify if the block is defined in the library or not
	* @var bool $in_lib
	*/
	public $in_lib;

	/**
	* Specify the name of the driver for the block
	* @var string $driver
	*/
	public $driver;
	
	/**
	* The absolute adress of the block on BI
	* @var int $addr_abs
	*/
	public $addr_abs;

	/**
	* Size of relative adress bus
	* @var int $size_addr_rel
	*/
	public $size_addr_rel;

	/**
	* Number of master in the block on BI
	* @var int $master_count
	*/
	public $master_count;

	/**
	* Specify the external file script to configure the block (optional)
	* @var string $scriptfile
	*/
	public $configscriptfile;

	/**
	* Specify the external file script to generate the block (optional)
	* @var string $generatescriptfile
	*/
	public $generatescriptfile;


	/**
	* Array of parameters class (can be Generic or dynamics parameter on BI)
	* @var array|Param $params
	*/
	public $params;
	
	/**
	* Array of property class specify the hight level properties
	* @var array|Property $properties
	*/
	public $properties;

	/**
	* Array of files whith define the implementation of the block
	* @var array|File $files
	*/
	public $files;
	
	/**
    * Array of flows in the block can be input flow or output
    * @var array|Flow $flows
    */
	public $flows;

	/**
	* Array of clocks to drive the block
	* @var array|Clock $clocks
	*/
	public $clocks;

	/**
	* Array of resets, can be different type of resets
	* @var array|Reset $resets
	*/
	public $resets;

	/**
	* External pins mapping for blocks abble to comunicate with the output
	* @var array|Pin $pins
	*/
	public $pins;

	/**
	* Array of port abble to comunicate with the output
	* @var array|Port $ext_ports
	*/
	public $ext_ports;

	/**
	* Array of interfaces of the block
	* @var array|InterfaceBus $interfaces
	*/
	public $interfaces;

	
	protected $xml;
	
	function __construct()
	{
		$this->params = array();
		$this->properties = array();
		$this->files = array();
		$this->flows = array();
		$this->clocks = array();
		$this->resets = array();
		$this->pins = array();
		$this->ext_ports = array();
		$this->interfaces = array();
		$this->addr_abs = -1;
		$this->master_count = 0;
		$this->configscriptfile='';
		$this->generatescriptfile='';
		
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
		if(!empty($this->configscriptfile))
		{
			if(file_exists($this->path.$this->configscriptfile))
			{
				$script = str_replace(LIB_PATH,'',$this->path.$this->configscriptfile);
				$configureBlock = (include $script);
				if($configureBlock!==FALSE)
				{
					$configureBlock($node, $block);
				}
			}
		}
	}
	
	function generate($node, $block, $path, $language)
	{
		if(!empty($this->generatescriptfile))
		{
			if(file_exists($this->path.$this->generatescriptfile))
			{
				$script = str_replace(LIB_PATH,'',$this->path.$this->generatescriptfile);
				$generateBlock = (include $script);
				if($generateBlock!==FALSE)
				{
					$generateBlock($node, $block, $path, $language);
				}
			}
		}
	}
	
	function getParam($name)
	{
		foreach($this->params as $param)
		{
			if($param->name==$name) return $param;
		}
		return null;
	}
	
	function getProperty($name)
	{
		foreach($this->properties as $property)
		{
			if($property->name==$name) return $property;
		}
		return null;
	}
	
	function getFile($name)
	{
		foreach($this->files as $file)
		{
			if($file->name==$name) return $file;
		}
		return null;
	}
	
	function getFlow($name)
	{
		foreach($this->flows as $flow)
		{
			if($flow->name==$name) return $flow;
		}
		return null;
	}
	
	function getClock($name)
	{
		foreach($this->clocks as $clock)
		{
			if($clock->name==$name) return $clock;
		}
		return null;
	}
	
	function getReset($name)
	{
		foreach($this->resets as $reset)
		{
			if($reset->name==$name) return $reset;
		}
		return null;
	}
	
	function getPin($name)
	{
		foreach($this->pins as $pin)
		{
			if($pin->name==$name) return $pin;
		}
		return null;
	}
	
	function getExtPort($name)
	{
		foreach($this->ext_ports as $extPort)
		{
			if($extPort->name==$name) return $extPort;
		}
		return null;
	}
	
	function getInterface($name)
	{
		foreach($this->interfaces as $interface)
		{
			if($interface->name==$name) return $interface;
		}
		return null;
	}
	
	protected function parse_xml()
	{
		$this->size_addr_rel = (int)$this->xml['size_addr_rel'];
		$this->configscriptfile = $this->xml['configscriptfile'];
		$this->generatescriptfile = $this->xml['generatescriptfile'];
		
		// files
		if(isset($this->xml->files))
		{
			foreach($this->xml->files->file as $file)
			{
				array_push($this->files, new File($file));
			}
		}
		
		// properties
		if(isset($this->xml->properties))
		{
			foreach($this->xml->properties->property as $property)
			{
				array_push($this->properties, new Property($property));
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
		
		// properties
		$xml_property = $xml->createElement("properties");
		foreach($this->properties as $property)
		{
			$xml_property->appendChild($property->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_property);
		
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
