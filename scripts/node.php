<?php

require_once("device.php");
require_once("block.php");
require_once("process.php");
require_once("fi.php");
require_once("bi.php");

class Node
{
	public $node_file;
	public $name;
	public $device;
	public $blocks;

	function __construct($node_file)
	{
		$this->blocks = array();
		
		$this->parse_config_xml($node_file);
	}
	
	function getBlock($name)
	{
		foreach($this->blocks as $block)
		{
			if($block->name==$name) return $block;
		}
		return null;
	}
	
	protected function parse_config_xml($node_file)
	{
		if (!file_exists($node_file)){echo "File $node_file doesn't exist\n";return;}
		if (!($xml = simplexml_load_file($node_file))){echo "Error when parsing $node_file \n";return;}
		$this->node_file = $node_file;
	
		$this->name = (string)$xml['name'];
		$this->device = new Device($xml->device, $this);
		
		// process
		if(isset($xml->process))
		{
			foreach($xml->process->process as $process)
			{
				array_push($this->blocks, new Process($process));
			}
		}
		//print_r($this->blocks);
		
		// add flow interconnect with config
		$flowInterconnect = new FlowInterconnect($xml->flow_interconnect);
		array_push($this->blocks, $flowInterconnect);
		$flowInterconnect->configure($this);
		
		// add bus interconnect
		$busInterconnect = new BusInterconnect();
		array_push($this->blocks, $busInterconnect);
		$busInterconnect->configure($this);
		
		
		unset($xml);
	}
}

?>
