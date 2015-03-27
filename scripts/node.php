<?php

require_once("board.php");
require_once("block.php");
require_once("process.php");
require_once("flow_connect.php");

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

	/**
	* Flow connections between blocks
	* @var array|FlowConnect $flow_connects
	*/
	public $flow_connects;

	function __construct($node_file=null)
	{
		$this->blocks = array();
		$this->connects = array();
		
		if($node_file) $this->parse_config_xml($node_file);
	}
	
	protected function parse_config_xml($node_file)
	{
		if (!file_exists($node_file)) error("File $node_file doesn't exist",5,"Node");
		if (!($xml = simplexml_load_file($node_file))) error("Error when parsing $node_file",5,"Node");
		$this->node_file = $node_file;
	
		$this->name = (string)$xml['name'];
		$this->board = new Board($xml->board, $this);
		
		// process
		if(isset($xml->process))
		{
			foreach($xml->process->process as $process)
			{
				$processBlock = new Process($process);
				
				// params
				if(isset($process->params))
				{
					foreach($process->params->param as $param)
					{
						if(isset($param['name']) and isset($param['value']))
						{
							$concerned_param = NULL;
							foreach($processBlock->params as $blockparam)
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
				
				array_push($this->blocks, $processBlock);
			}
		}
		
		// flow connections
		if(isset($xml->flow_interconnect))
		{
			if(isset($xml->flow_interconnect->connects))
			{
				foreach($xml->flow_interconnect->connects->connect as $connect)
				{
					array_push($this->connects, new FlowConnect($connect));
				}
			}
		}
		
		unset($xml);
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
	
	function getBlock($name)
	{
		foreach($this->blocks as $block)
		{
			if($block->name==$name) return $block;
		}
		return null;
	}
	
	function getFlowConnect($name)
	{
		foreach($this->flow_connects as $flow_connect)
		{
			if($flow_connect->name==$name) return $flow_connect;
		}
		return null;
	}
}

?>
