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

class Port
{
	/**
	* Name of the interface
	* @var string $name
	*/
	public $name;
	
	/**
	* Type of the port
	* @var string $type
	*/
	public $type;
	
	/**
	* Size of the port in bit
	* @var int $size
	*/
	public $size;
	
	/**
	* Description of the port (optional)
	* @var string $desc
	*/
	public $desc;

	/**
	* Reference to the associated parent block
	* @var Block $parentBlock
	*/
	public $parentBlock;
	
	function __construct($xml=null)
	{
		$this->parentBlock = null;
		if($xml) $this->parse_xml($xml);
	}
	
	public function __toString()
    {
		return "port ".$this->name." type: ".$this->type." size: ".$this->size;
    }
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->type		= (string)$xml['type'];
		$this->size		= (string)$xml['size'];
		$this->desc		= (string)$xml['desc'];
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("port");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// type
		$att = $xml->createAttribute('type');
		$att->value = $this->type;
		$xml_element->appendChild($att);
		
		// size
		$att = $xml->createAttribute('size');
		$att->value = $this->size;
		$xml_element->appendChild($att);
		
		// desc
		$att = $xml->createAttribute('desc');
		$att->value = $this->desc;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
