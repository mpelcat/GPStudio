<?php

require_once("board.php");
require_once("block.php");
require_once("process.php");
require_once("flow_connect.php");

class Node
{
	public $node_file;
	public $name;
	public $board;
	public $blocks;
	public $flow_connects;

	function __construct($node_file)
	{
		$this->blocks = array();
		$this->connects = array();
		
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
		$this->board = new Board($xml->board, $this);
		
		// process
		if(isset($xml->process))
		{
			foreach($xml->process->process as $process)
			{
				array_push($this->blocks, new Process($process));
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
}

?>
