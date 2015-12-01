<?php

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
