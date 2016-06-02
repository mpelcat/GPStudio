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

require_once("attribute.php");

class Toolchain
{
	/**
	* @brief Array of attributes of the toolchain (optional)
	* @var array|Attribute $attributes
	*/
	public $attributes;
	
	function __construct($xml=null)
	{
		$this->attributes = array();
		
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		
		// attributes
		if(isset($xml->attributes))
		{
			foreach($xml->attributes->attribute as $attribute)
			{
				$this->addAttribute(new Attribute($attribute));
			}
		}
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("toolchain");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// attributes
		if(!empty($this->attributes))
		{
			$xml_attributes = $xml->createElement("attributes");
			foreach($this->attributes as $attribute)
			{
				$xml_attributes->appendChild($attribute->getXmlElement($xml, $format));
			}
			$xml_element->appendChild($xml_attributes);
		}
		
		return $xml_element;
	}
	
	public function configure_project($node)
	{
	}
	
	public function generate_project($node, $path)
	{
	}
	
	static public function load($toolchain_name, $xml=null)
	{
		switch ($toolchain_name)
		{
			case 'hdl':
				require_once("toolchain/hdl/hdl.php");
				return new HDL_toolchain($xml);
				break;
			case 'altera_quartus':
				require_once("toolchain/altera_quartus/altera_quartus.php");
				return new Altera_quartus_toolchain($xml);
				break;
			default:
				throw new Exception ('Toolchain \''.$toolchain_name.'\' doesn\'t exists.');
		}
	}
	
	/** Add a attribute to the toolchain 
	 *  @param Attribute $attribute attribute to add to the toolchain **/
	function addAttribute($attribute)
	{
		array_push($this->attributes, $attribute);
	}
	
	/** return a reference to the attribute with the name $name, if not found, return false
	 *  @param string $name name of the attribute enum to search
	 *  @return Attribute found attribute **/
	function getAttribute($name)
	{
		foreach($this->attributes as $attribute)
		{
			if($attribute->name==$name) return $attribute;
		}
		return null;
	}
	
	function getRessourceAttributes($type)
	{
		$attr = array();
		return $attr;
	}
	
	function getRessourceDeclare($type)
	{
		$declare='';
		return $declare;
	}
}

?>
