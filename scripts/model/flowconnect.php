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

class FlowConnect
{
	/**
	* Name of the block source of the flow
	* @var string $fromblock
	*/
	public $fromblock;

	/**
	* Name of the flow on the block source of the flow
	* @var string $fromflow
	*/
	public $fromflow;

	/**
	* Name of the block sink of the flow
	* @var string $toblock
	*/
	public $toblock;

	/**
	* Name of the flow on the block sink of the flow
	* @var string $toflow
	*/
	public $toflow;

	/**
	* Byte ordering can be "msb" or "lsb", default value is "msb"
	* @var string $order
	*/
	public $order;
	
	function __construct($fromBlock=NULL, $fromFlow=NULL, $toBlock=NULL, $toFlow=NULL, $order='msb')
	{
		$this->order='msb';
		if($fromBlock!=NULL)
		{
			if(is_object($fromBlock) and get_class($fromBlock)==='SimpleXMLElement')
			{
				$xml=$fromBlock;
				$this->parse_xml($xml);
			}
			else
			{
				$this->fromblock = $fromBlock;
				$this->fromflow = $fromFlow;
				$this->toblock = $toBlock;
				$this->toflow = $toFlow;
				$this->order = $order;
			}
		}
	}
	
	protected function parse_xml($xml)
	{
		$this->fromblock = (string)$xml['fromblock'];
		$this->fromflow = (string)$xml['fromflow'];
		$this->toblock = (string)$xml['toblock'];
		$this->toflow = (string)$xml['toflow'];
		if(isset($xml['order'])) $this->order = (string)$xml['order']; else $this->order = 'msb';
	}
	
	public function getXmlElement($xml, $format)
	{
		if($format=="project")
		{
			$xml_element = $xml->createElement("connect");
		}
		else
		{
			$xml_element = $xml->createElement("flow_connect");
		}
		
		// fromblock
		$att = $xml->createAttribute('fromblock');
		$att->value = $this->fromblock;
		$xml_element->appendChild($att);
		
		// fromflow
		$att = $xml->createAttribute('fromflow');
		$att->value = $this->fromflow;
		$xml_element->appendChild($att);
		
		// toblock
		$att = $xml->createAttribute('toblock');
		$att->value = $this->toblock;
		$xml_element->appendChild($att);
		
		// toflow
		$att = $xml->createAttribute('toflow');
		$att->value = $this->toflow;
		$xml_element->appendChild($att);
		
		// order
		$att = $xml->createAttribute('order');
		$att->value = $this->order;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
