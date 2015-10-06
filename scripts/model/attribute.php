<?php

/** 
 * Attribute is contained into the Board class to define the specific attributes of the board and in Pin class to define each features of pin dedicated to the toolchain.
 * @brief The Attribute class is used to define special attributes for a toolchain.
 * @see Toolchain Pin Board
 * @ingroup base
 */

class Attribute
{
	/**
	* Pin name to map
	* @var string $name
	*/
	public $name;
	
	/**
	* Value of the attibute
	* @var string $value
	*/
	public $value;
	
	/**
	* Type of attribute
	* @var string $type
	*/
	public $type;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->value	= (string)$xml['value'];
		$this->type		= (string)$xml['type'];
	}
	
	public function getXmlElement($xml)
	{
		$xml_element = $xml->createElement("attribute");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// value
		$att = $xml->createAttribute('value');
		$att->value = $this->value;
		$xml_element->appendChild($att);
		
		// type
		$att = $xml->createAttribute('type');
		$att->value = $this->type;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}
