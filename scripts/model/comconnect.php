<?php

/* 
 * Copyright (C) 2014 Dream IP
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

class ComConnect
{
	/**
	* Attribute name
	* @var string $link
	*/
	public $link;
	
	/**
	* Value of the id
	* @var string $id
	*/
	public $id;
	
	/**
	* Type of connection, could be "flow", "paramin" or "paramout"
	* @var string $type
	*/
	public $type;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->link		= (string)$xml['link'];
		$this->id		= (string)$xml['id'];
		$this->type		= (string)$xml['type'];
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("com_connect");
		
		// link
		$att = $xml->createAttribute('link');
		$att->value = $this->link;
		$xml_element->appendChild($att);
		
		// id
		$att = $xml->createAttribute('id');
		$att->value = $this->id;
		$xml_element->appendChild($att);
		
		// type
		$att = $xml->createAttribute('type');
		$att->value = $this->type;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}
