<?php

/* 
 * Copyright (C) 2016 Dream IP
 * 
 * This file is part of GPStudio.
 *
 * GPStudio is a free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

require_once("board.php");
require_once("block.php");
require_once("process.php");

class Node
{
	/**
	* @brief The complete path of the file of the input definition
	* @var string $node_file
	*/
	public $node_file;

	/**
	* @brief Name of the node
	* @var string $name
	*/
	public $name;

	/**
	* @brief Board structure of the node
	* @var Board $board
	*/
	public $board;

	/**
	* @brief Array of al the blocks (process or io) contain in the node
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
		$this->node_file = realpath($node_file);
	
		$this->name = (string)$this->xml['name'];
		
		if(isset($this->xml->board))
		{
			$this->board = new Board($this->xml->board, $this);
		}
		
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
						if(isset($property->properties))
						{
							foreach($property->properties->property as $childPropertyXml)
							{
								if(isset($childPropertyXml['name']) and isset($childPropertyXml['value']))
								{
									if($concerned_property=$processBlock->getPropertyPath($property['name'].'.'.(string)$childPropertyXml['name']))
									{
										$concerned_property->value = $childPropertyXml['value'];
									}
									else
									{
										warning('property '.$property['name'].'.'.$childPropertyXml['name']." does'nt exists",16,$processBlock->name);
									}
								}
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
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("node");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// board
		if(isset($this->board))
		{
			$xml_element->appendChild($this->board->getXmlElement($xml, $format));
		}
		
		if($format=="complete")
		{
			// blocks
			$xml_blocks = $xml->createElement("blocks");
			foreach($this->blocks as $block)
			{
				$xml_blocks->appendChild($block->getXmlElement($xml, $format));
			}
			$xml_element->appendChild($xml_blocks);
		}
		elseif($format=="project")
		{
			// process
			$xml_blocks = $xml->createElement("process");
			foreach($this->blocks as $block)
			{
				if($block->type()=="process") $xml_blocks->appendChild($block->getXmlElement($xml, $format));
			}
			$xml_element->appendChild($xml_blocks);
			
			// special blocks
			foreach($this->blocks as $block)
			{
				if($block->type()!="process" and $block->type()!="io" and $block->type()!="iocom")
				{
					$xml_element->appendChild($block->getXmlElement($xml, $format));
				}
			}
		}
		
		return $xml_element;
	}
	
	function setBoard($boardName)
	{
		if(isset($this->board))
		{
			unset($this->board);
		}
		$this->board = new Board($boardName, $this);
	}
	
	function addIo($ioName)
	{
		if(isset($this->board))
		{
			$this->board->addIo($ioName);
		}
	}
	
	function delIo($ioName)
	{
		$i=0;
		foreach($this->blocks as $block)
		{
			if($block->name==$ioName and ($block->type()=="io" or $block->type()=="iocom")) unset($this->blocks[$i]);
			$i++;
		}
	}
	
	function addProcess($processName, $processDriver)
	{
		$process = new Process($processDriver);
		$process->name = $processName;
		$this->addBlock($process);
	}
	
	function delProcess($ioProcess)
	{
		$i=0;
		foreach($this->blocks as $block)
		{
			if($block->name==$ioProcess and $block->type()=="process") unset($this->blocks[$i]);
			$i++;
		}
	}
	
	function saveXml($file)
	{
		$xml = new DOMDocument("1.0", "UTF-8");
		$xml->preserveWhiteSpace = false;
		$xml->formatOutput = true;
		
		$xml->appendChild($this->getXmlElement($xml, "complete"));
		
		$xml->save($file);
	}
	
	function saveProject($file)
	{
		$xml = new DOMDocument("1.0", "UTF-8");
		$xml->preserveWhiteSpace = false;
		$xml->formatOutput = true;
		
		$xml->appendChild($this->getXmlElement($xml, "project"));
		
		$xml->save($file);
	}
	
	/** Add a block to the node 
	 *  @param Block $block block to add to the node **/
	function addBlock($block)
	{
		$block->parentNode = $this;
		$block->toGlobalPropertyPath();
		
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
	
	function getFlow($name)
	{
		$subPath=explode('.',$name);
		if(count($subPath)!=2) return NULL;
		$block=$this->getBlock($subPath[0]);
		if($block==NULL) return NULL;
		$flow=$block->getFlow($subPath[1]);
		return $flow;
	}
}

?>
