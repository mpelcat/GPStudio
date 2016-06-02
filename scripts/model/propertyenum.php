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

class PropertyEnum
{
	/**
	* @brief Name of the enum
	* @var string $name
	*/
	public $name;
	
	/**
	* @brief Caption of the property for high level interface (can contain space)
	* @var string $caption
	*/
	public $caption;

	/**
	* @brief Coresponding value of the enum when this enum is chosen
	* @var string $value
	*/
	public $value;

	/**
	* @brief Description of the enum (optional)
	* @var string $desc
	*/
	public $desc;

	/**
	* @brief Reference to the associated parent Property
	* @var Property $parentProperty
	*/
	public $parentProperty;

	
	function __construct($xml=null)
	{
		$this->parentProperty = null;
		if($xml) $this->parse_xml($xml);
	}
	
	public function __toString()
    {
        $string=$this->name." caption:'".$this->caption."' value:'".$this->value."' desc:'".$this->desc."'";
        return $string;
    }
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->caption	= (string)$xml['caption'];
		if($this->caption=='') $this->caption = $this->name;
		$this->value	= (string)$xml['value'];
		$this->desc		= (string)$xml['desc'];
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("enum");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// value
		$att = $xml->createAttribute('value');
		$att->value = $this->value;
		$xml_element->appendChild($att);
		
		if($format=="complete" or $format=="blockdef")
		{
			// caption
			$att = $xml->createAttribute('caption');
			$att->value = $this->caption;
			$xml_element->appendChild($att);
		
			// desc
			$att = $xml->createAttribute('desc');
			$att->value = $this->desc;
			$xml_element->appendChild($att);
		}
		
		return $xml_element;
	}
}

?>
