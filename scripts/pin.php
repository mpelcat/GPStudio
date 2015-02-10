<?php

class Pin
{
	public $name;
	public $mapto;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->mapto	= (string)$xml['mapto'];
	}
	
	public function getXmlElement($xml)
	{
		$xml_element = $xml->createElement("pin");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// mapto
		$att = $xml->createAttribute('mapto');
		$att->value = $this->mapto;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
