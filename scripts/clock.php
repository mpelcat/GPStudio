<?php

class Clock
{
	/**
	* Name of the clock
	* @var string $name
	*/
	public $name;

	/**
	* Specify if clock is in or out (value : "in" or "out", default "in")
	* @var string $direction
	*/
	public $direction;

	/**
	* Phase shift of the clock (in degree)
	* @var int $shift
	*/
	public $shift;

	/**
	* Minimal value for this clock in Hz
	* @var float $min
	*/
	public $min;

	/**
	* Maximal value for this clock in Hz
	* @var float $max
	*/
	public $max;

	/**
	* Typical value for this clock in Hz
	* @var float $typical
	*/
	public $typical;

	/**
	* Clock domain. Clocks in the same domain depend of the same clock source
	* @var string $domain
	*/
	public $domain;

	/**
	* Clock net, physical net name to connect the clock. This value is computed by CI
	* @var string $net
	*/
	public $net;

	/**
	* Description of the clock (optional)
	* @var string $desc
	*/
	public $desc;

	/**
	* Reference to the associated parent block
	* @var Block $parentBlock
	*/
	public $parentBlock;
	
	function __construct($xml=null)
	{
		$this->parentBlock = null;
		$this->group = "";
		$this->direction = "in";
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name			= (string)$xml['name'];
		if(isset($xml['domain'])) $this->domain = (string)$xml['domain']; else $this->domain = "";
		if(isset($xml['direction'])) $this->direction = (string)$xml['direction']; else $this->direction = "in";
		if(isset($xml['shift'])) $this->shift = (int)$xml['shift']; else $this->shift = 0;
		if(isset($xml['min'])) $this->min	= (int)$xml['min'];
		if(isset($xml['max'])) $this->min	= (int)$xml['max'];
		$this->typical		= (string)$xml['typical'];
		$this->desc			= (string)$xml['desc'];
	}
	
	public function getXmlElement($xml)
	{
		$xml_element = $xml->createElement("clock");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// domain
		$att = $xml->createAttribute('domain');
		$att->value = $this->domain;
		$xml_element->appendChild($att);
		
		// net
		$att = $xml->createAttribute('net');
		$att->value = $this->net;
		$xml_element->appendChild($att);
		
		// direction
		$att = $xml->createAttribute('direction');
		$att->value = $this->direction;
		$xml_element->appendChild($att);
		
		// shift
		$att = $xml->createAttribute('shift');
		$att->value = $this->shift;
		$xml_element->appendChild($att);
		
		// min
		$att = $xml->createAttribute('min');
		$att->value = $this->min;
		$xml_element->appendChild($att);
		
		// max
		$att = $xml->createAttribute('max');
		$att->value = $this->max;
		$xml_element->appendChild($att);
		
		// typical
		$att = $xml->createAttribute('typical');
		$att->value = $this->typical;
		$xml_element->appendChild($att);
		
		// desc
		$att = $xml->createAttribute('desc');
		$att->value = $this->desc;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
