<?php

class ClockDomain
{
	/**
	* Name of the clock
	* @var string $name
	*/
	public $name;

	/**
	* Typical value for this clock in Hz, could be written like this : 14.2M or 18.7k or 1500
	* @var float $typical
	*/
	public $typical;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name	= (string)$xml['name'];
		$this->typical = Clock::convert($xml['typical']);
	}
	
	public function getXmlElement($xml)
	{
		$xml_element = $xml->createElement("clock");
		
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
