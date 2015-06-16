<?php

require_once("board.php");
require_once("block.php");
require_once("process.php");

class Node
{
	/**
	* The complete path of the file of the input definition
	* @var string $node_file
	*/
	public $node_file;

	/**
	* Name of the node
	* @var string $name
	*/
	public $name;

	/**
	* Board structure of the node
	* @var Board $board
	*/
	public $board;

	/**
	* Array of al the blocks (process or io) contain in the node
	* @var array|Block $blocks
	*/
	public $blocks;
	
	public $xml;

	function __construct($node_file=null)
	{
		$this->blocks = array();
		
		if($node_file) $this->parse_config_xml($node_file);
	}
	
	protected function parse_config_xml($node_file)
	{
		if (!file_exists($node_file)) error("File $node_file doesn't exist",5,"Node");
		if (!($this->xml = simplexml_load_file($node_file))) error("Error when parsing $node_file",5,"Node");
		$this->node_file = $node_file;
	
		$this->name = (string)$this->xml['name'];
		$this->board = new Board($this->xml->board, $this);
		
		// process
		if(isset($this->xml->process))
		{
			foreach($this->xml->process->process as $process)
			{
				$processBlock = new Process($process);
				
				// redef params
				if(isset($process->params))
				{
					foreach($process->params->param as $param)
					{
						if(isset($param['name']) and isset($param['value']))
						{
							if($concerned_param=$processBlock->getParam((string)$param['name']))
							{
								$concerned_param->value = $param['value'];
							}
							else
							{
								warning('parameter '.$param['name']." does'nt exists",16,$processBlock->name);
							}
						}
					}
				}
				
				// redef properties
				if(isset($process->properties))
				{
					foreach($process->properties->property as $property)
					{
						if(isset($property['name']) and isset($property['value']))
						{
							if($concerned_property=$processBlock->getPropertyPath((string)$property['name']))
							{
								$concerned_property->value = $property['value'];
							}
							else
							{
								warning('property '.$property['name']." does'nt exists",16,$processBlock->name);
							}
						}
					}
				}
				
				// redef flow size
				if(isset($process->flows))
				{
					foreach($process->flows->flow as $flow)
					{
						if(isset($flow['name']) and isset($flow['size']))
						{
							if($concerned_flow=$processBlock->getFlow((string)$flow['name']))
							{
								$concerned_flow->size = (int)$flow['size'];
							}
							else
							{
								warning('flow '.$flow['name']." does'nt exists",16,$processBlock->name);
							}
						}
					}
				}
				
				// redef clock freq
				if(isset($process->clocks))
				{
					foreach($process->clocks->clock as $clock)
					{
						if(isset($clock['name']) and isset($clock['typical']))
						{
							if($concerned_clock=$processBlock->getClock((string)$clock['name']))
							{
								$concerned_clock->typical = Clock::convert($clock['typical']);
							}
							else
							{
								warning('clock '.$clock['name']." does'nt exists",16,$processBlock->name);
							}
						}
					}
				}
				
				$this->addBlock($processBlock);
			}
		}
	}
	
	public function getXmlElement($xml)
	{
		$xml_element = $xml->createElement("node");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// toolchain
		$xml_element->appendChild($this->board->toolchain->getXmlElement($xml));
		
		// blocks
		$xml_blocks = $xml->createElement("blocks");
		foreach($this->blocks as $block)
		{
			$xml_blocks->appendChild($block->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_blocks);
		
		return $xml_element;
	}
	
	function saveXml($file)
	{
		$xml = new DOMDocument();
		$xml->preserveWhiteSpace = false;
		$xml->formatOutput = true;
		
		$xml->appendChild($this->getXmlElement($xml));
		
		$xml->save($file);
	}
	
	/** Add a block to the node 
	 *  @param Block $interface interface to add to the block **/
	function addBlock($block)
	{
		$block->parentNode = $this;
		array_push($this->blocks, $block);
	}
	
	/** return a reference to the block with the name $name, if not found, return false
	 *  @param string $name name of the block to search
	 *  @return Block found block **/
	function getBlock($name)
	{
		foreach($this->blocks as $block)
		{
			if($block->name==$name) return $block;
		}
		return null;
	}
}

?>
