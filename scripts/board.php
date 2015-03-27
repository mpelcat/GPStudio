<?php

require_once("io.php");

class Board
{
	private $xml;
	
	/**
	* Complete path of the board definition
	* @var string $board_file
	*/
	public $board_file;

	/**
	* Name of the board
	* @var string $name
	*/
	public $name;

	/**
	* Toolchain structure of board
	* @var Toolchain $toolchain
	*/
	public $toolchain;

	/**
	* Array of pin mapping of the board
	* @var array|Pin $pins
	*/
	public $pins;

	/**
	* Array of input clocks of the board
	* @var array|Clock $clocks
	*/
	public $clocks;

	/**
	* Array of input resets of the board
	* @var array|Reset $resets
	*/
	public $resets;


	function __construct($board_element, $node)
	{
		$this->pins = array();
		$this->clocks = array();
		$this->resets = array();
		
		$board_name = $board_element['name'];
		
		// open device define file (.dev)
		$this->board_file = LIB_PATH . "board" . DIRECTORY_SEPARATOR . $board_name . DIRECTORY_SEPARATOR . $board_name . ".dev";
		if (!file_exists($this->board_file)) error("File $this->board_file doesn't exist",5,"Board");
		if (!($this->xml = simplexml_load_file($this->board_file))) error("Error when parsing $this->board_file",5,"Board");
		
		$this->parse_xml($board_element, $node);
		unset($this->xml);
	}
	
	private function parse_xml($board_element, $node)
	{
		$this->name = (string)$this->xml['name'];
		
		$this->toolchain = new Toolchain($this->xml->toolchain);
		
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
		
		// replace default param value directly in .node file
		foreach($board_element->ios->io as $io)
		{
			if(isset($io->params))
			{
				$concerned_block = NULL;
				foreach($node->blocks as $block)
				{
					if($block->name==$io['name']) $concerned_block=$block;
				}
				if($concerned_block!=NULL)
				{
					foreach($io->params->param as $param)
					{
						if(isset($param['name']) and isset($param['value']))
						{
							$concerned_param = NULL;
							foreach($block->params as $blockparam)
							{
								if($blockparam->name==$param['name']) $concerned_param=$blockparam;
							}
							if($concerned_param)
							{
								$concerned_param->value = $param['value'];
							}
						}
					}
				}
			}
		}
	}
}

?>
