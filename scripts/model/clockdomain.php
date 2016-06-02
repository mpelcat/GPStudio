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

/** 
 * ClockDomain permits to save typical frequency of a clock domain.
 * @brief ClockDomain permits to save typical frequency of a clock domain.
 * @see Clock ClockInterconnect
 * @ingroup base
 */

class ClockDomain
{
	/**
	* @brief Name of the clock
	* @var string $name
	*/
	public $name;

	/**
	* @brief Typical value for this clock in Hz, could be written like this : 14.2M or 18.7k or 1500
	* @var float $typical
	*/
	public $typical;
	
	function __construct($name=null, $typical=null)
	{
		if(is_object($name) and get_class($name)==='SimpleXMLElement')
		{
			$xml=$name;
			$this->parse_xml($xml);
		}
		else
		{
			$this->name = $name;
			$this->typical = $typical;
		}
	}
	
	protected function parse_xml($xml)
	{
		$this->name	= (string)$xml['name'];
		$this->typical = Clock::convert($xml['typical']);
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("domain");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// typical
		$att = $xml->createAttribute('typical');
		$att->value = $this->typical;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
