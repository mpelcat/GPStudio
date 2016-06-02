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

class Reset
{
	/**
	* @brief Name of the reset
	* @var string $name
	*/
	public $name;
	
	/**
	* @brief Name of the group reset
	* @var string $group
	*/
	public $group;
	
	/**
	* @brief Direction of the reset to specify if it's a source reset ('out') or an input reset ('in')
	* @var string $direction
	*/
	public $direction;

	/**
	* @brief Description of the reset (optional)
	* @var string $desc
	*/
	public $desc;

	/**
	* @brief Reference to the associated parent block
	* @var Block $parentBlock
	*/
	public $parentBlock;
	
	function __construct($xml=null)
	{
		$this->direction = 'in';
		$this->parentBlock = null;
		if($xml) $this->parse_xml($xml);
	}
	
	public function __toString()
    {
        return $this->name." ".$this->group." ".$this->direction;
    }
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->group	= (string)$xml['group'];
		$this->direction= (string)$xml['direction'];
		$this->desc		= (string)$xml['desc'];
	}
	
	public function getXmlElement($xml)
	{
		$xml_element = $xml->createElement("reset");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// group
		$att = $xml->createAttribute('group');
		$att->value = $this->group;
		$xml_element->appendChild($att);
		
		// direction
		$att = $xml->createAttribute('direction');
		$att->value = $this->direction;
		$xml_element->appendChild($att);
		
		// desc
		$att = $xml->createAttribute('desc');
		$att->value = $this->desc;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
