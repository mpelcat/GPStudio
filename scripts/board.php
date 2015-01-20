<?php

require_once("io.php");

class Board
{
	private $xml;
	
	public $board_file;
	public $name;
	public $type;
	
	public $pins;
	public $clocks;
	public $resets;

	function __construct($board_element, $node)
	{
		$this->pins = array();
		$this->clocks = array();
		$this->resets = array();
		
		$board_name = $board_element['name'];
		
		// open device define file (.dev)
		$this->board_file = LIB_PATH . "board" . DIRECTORY_SEPARATOR . $board_name . DIRECTORY_SEPARATOR . $board_name . ".dev";
		if (!file_exists($this->board_file)){echo "File $this->board_file doesn't exist\n";return;}
		if (!($this->xml = simplexml_load_file($this->board_file))){echo "Error when parsing $this->board_file \n";return;}
		
		$this->parse_xml($board_element, $node);
		unset($this->xml);
	}
	
	private function parse_xml($board_element, $node)
	{
		$this->name = (string)$this->xml['name'];
		$this->type = (string)$this->xml->toolchain['type'];
		
		$this->parse_ios($board_element, $node);
		
		// clocks
		if(isset($this->xml->global->clocks))
		{
			foreach($this->xml->global->clocks->clock as $clock)
			{
				array_push($this->clocks, new Clock($clock));
			}
		}
		
		// resets
		if(isset($this->xml->global->resets))
		{
			foreach($this->xml->global->resets->reset as $reset)
			{
				array_push($this->resets, new Reset($reset));
			}
		}
		
		// pins
		if(isset($this->xml->global->pins))
		{
			foreach($this->xml->global->pins->pin as $pin)
			{
				array_push($this->pins, new Pin($pin));
			}
		}
	}
	
	private function parse_ios($board_element, $node)
	{
		$used_ios = array();
		
		// add all used ios
		foreach($board_element->ios->io as $io)
		{
			$io_name = (string)$io['name'];
			$used_ios[$io_name] = $io;
		}
		foreach($this->xml->ios->io as $io)
		{
			$io_name = (string)$io['name'];
			if(array_key_exists($io_name, $used_ios))
			{
				array_push($node->blocks, new IO($io, $used_ios[$io_name]));
			}
			elseif($io['optional']!="true")
			{
				//array_push($node->blocks, new IO($io, null));
			}
		}
		//print_r($this->ios);
	}
}

?>
