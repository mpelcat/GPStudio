<?php

class Reset
{
	/**
	* Name of the reset
	* @var string $name
	*/
	public $name;
	
	/**
	* Name of the group reset
	* @var string $group
	*/
	public $group;
	
	/**
	* Direction of the reset to specify if it's a source reset ('out') or an input reset ('in')
	* @var string $direction
	*/
	public $direction;

	/**
	* Description of the reset (optional)
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
