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

	/**
	* Reference to the associated parent node
	* @var Node $parentNode
	*/
	public $parentNode;


	function __construct($board_element, $node)
	{
		$this->parentNode = $node;
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
		
		$this->toolchain = Toolchain::load($this->xml->toolchain['name'], $this->xml->toolchain);
		
		$this->parse_ios($board_element, $node);
		
		// clocks
		if(isset($this->xml->global->clocks))
		{
			foreach($this->xml->global->clocks->clock as $clockXml)
			{
				$this->addClock(new Clock($clockXml));
			}
		}
		
		// resets
		if(isset($this->xml->global->resets))
		{
			foreach($this->xml->global->resets->reset as $resetXml)
			{
				$this->addReset(new Reset($resetXml));
			}
		}
		
		// pins
		if(isset($this->xml->global->pins))
		{
			foreach($this->xml->global->pins->pin as $pin)
			{
				$this->addPin(new Pin($pin));
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
				$node->addBlock(new IO($io, $used_ios[$io_name]));
			}
			elseif($io['optional']!="true")
			{
				//$node->addBlock(new IO($io, null));
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
	
	/** Add a clock to the block 
	 *  @param Clock $clock clock to add to the block **/
	function addClock($clock)
	{
		$clock->parentBlock = $this;
		array_push($this->clocks, $clock);
	}
	
	/** return a reference to the clock with the name $name, if not found, return false
	 *  @param string $name name of the clock to search
	 *  @return Clock found clock **/
	function getClock($name)
	{
		foreach($this->clocks as $clock)
		{
			if($clock->name==$name) return $clock;
		}
		return null;
	}
	
	/** Add a reset to the block 
	 *  @param Reset $reset reset to add to the block **/
	function addReset($reset)
	{
		$reset->parentBlock = $this;
		array_push($this->resets, $reset);
	}
	
	/** return a reference to the reset with the name $name, if not found, return false
	 *  @param string $name name of the reset to search
	 *  @return Reset found reset **/
	function getReset($name)
	{
		foreach($this->resets as $reset)
		{
			if($reset->name==$name) return $reset;
		}
		return null;
	}
	
	/** Add a pin to the block 
	 *  @param Pin $pin pin to add to the block **/
	function addPin($pin)
	{
		$pin->parentBlock = $this;
		array_push($this->pins, $pin);
	}
	
	/** return a reference to the pin with the name $name, if not found, return false
	 *  @param string $name name of the pin to search
	 *  @return Pin found pin **/
	function getPin($name)
	{
		foreach($this->pins as $pin)
		{
			if($pin->name==$name) return $pin;
		}
		return null;
	}
}

?>
