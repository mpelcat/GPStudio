<?php

class ParamEnum
{
	/**
	* Name of the enum
	* @var string $name
	*/
	public $name;

	/**
	* Coresponding value of the enum when this enum is chosen
	* @var string $value
	*/
	public $value;

	/**
	* Description of the enum (optional)
	* @var string $desc
	*/
	public $desc;

	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->value	= (string)$xml['value'];
		$this->desc		= (string)$xml['desc'];
	}
	
	public function getXmlElement($xml)
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
		
		// desc
		$att = $xml->createAttribute('desc');
		$att->value = $this->desc;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
