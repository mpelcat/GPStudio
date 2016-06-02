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

class ParamBitfield
{
	/**
	* @brief Name of the bitfield
	* @var string $name
	*/
	public $name;

	/**
	* @brief Type of the value
	* @var string $type
	*/
	public $type;

	/**
	* @brief Current value of the bitfield
	* @var string $value
	*/
	public $value;

	/**
	* @brief Bitfield in text format
	* @var string $bitfield
	* @exemple "2-0" "2,6,1" "15-4,0"
	*/
	public $bitfield;

	/**
	* @brief Mapping to properties (optional)
	* @var string $propertymap
	*/
	public $propertymap;

	/**
	* @brief Description of the bitfield (optional)
	* @var string $desc
	*/
	public $desc;

	/**
	* @brief Array of int for concerned bit in the param
	* @var array|int $bitfieldlist
	*/
	public $bitfieldlist;

	/**
	* @brief Reference to the associated parent Param
	* @var Param $parentParam
	*/
	public $parentParam;
	
	function __construct($xml=null)
	{
		$this->bitfieldlist = array();
		$this->paramenums = array();
		$this->parentParam = NULL;
		if($xml) $this->parse_xml($xml);
	}
	
	public function __toString()
    {
		return "bitfield ".$this->name." bitfield: ".$this->bitfield." propertymap: '".$this->propertymap."'";
    }
	
	protected function parse_xml($xml)
	{
		$this->name			= (string)$xml['name'];
		$this->type			= (string)$xml['type'];
		$this->value		= (string)$xml['value'];
		$this->value		= (string)$xml['value'];
		$this->propertymap	= (string)$xml['propertymap'];
		$this->desc			= (string)$xml['desc'];
		
		if(isset($xml['bitfield']))
		{
			$bitfield = (string)$xml['bitfield'];
			if(!empty($bitfield) or $bitfield=="0")
			{
				$this->bitfield		= $bitfield;
				$this->bitfieldlist = ParamBitfield::decodeBitField($bitfield);
			}
		}
	}
	
	public static function decodeBitField($string)
	{
		$bitfieldlist = array();
		// bitfield support with exp like 3,0 => [3 0] or 3-0 => [3 2 1 0] or 6-4,0 => [6 5 4 0]
		preg_match_all("|([-,]?)([0-9])|", $string, $out, PREG_SET_ORDER);
		
		$prev=-1;
		$lastsymbole='';
		foreach($out as $bitdesc)
		{
			$bit = $bitdesc[2];
			$symbole = $bitdesc[1];
			
			if($bit > 31) break;
			
			if($symbole==',')
			{
				if($lastsymbole==',' or $lastsymbole=='') array_push($bitfieldlist, $prev);
			}
			elseif($symbole=='-')
			{
				if($prev<$bit)
				{
					for($i=$prev; $i<=$bit; $i++) array_push($bitfieldlist, $i);
				}
				else
				{
					for($i=$prev; $i>=$bit; $i--) array_push($bitfieldlist, $i);
				}
			}
			
			$prev = $bit;
			$lastsymbole = $symbole;
		}
		if(($lastsymbole==',' or $lastsymbole=='') and $prev!=-1) array_push($bitfieldlist, $prev);
		return $bitfieldlist;
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("bitfield");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// type
		$att = $xml->createAttribute('type');
		$att->value = $this->type;
		$xml_element->appendChild($att);
		
		// value
		$att = $xml->createAttribute('value');
		$att->value = $this->value;
		$xml_element->appendChild($att);
		
		// bitfield
		$att = $xml->createAttribute('bitfield');
		$att->value = $this->bitfield;
		$xml_element->appendChild($att);
		
		// propertymap
		$att = $xml->createAttribute('propertymap');
		$att->value = $this->propertymap;
		$xml_element->appendChild($att);
		
		// desc
		$att = $xml->createAttribute('desc');
		$att->value = $this->desc;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
