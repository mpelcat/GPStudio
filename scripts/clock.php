<?php

class Clock
{
	/**
	* Name of the clock
	* @var string $name
	*/
	public $name;

	/**
	* Name of the group clock
	* @var string $group
	*/
	public $group;

	/**
	* Specify if clock is in or out (value : "in" or "out", default "in")
	* @var string $direction
	*/
	public $direction;

	/**
	* Phase shift of the clock (future use)
	* @var int $shift
	*/
	public $shift;

	/**
	* Minimal value for this clock in MHz
	* @var float $min
	*/
	public $min;

	/**
	* Maximal value for this clock in MHz
	* @var float $max
	*/
	public $max;

	/**
	* Typical value for this clock in MHz
	* @var float $typical
	*/
	public $typical;

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
		if(isset($xml['group'])) $this->group = (string)$xml['group']; else $this->group = "";
		if(isset($xml['direction'])) $this->direction = (string)$xml['direction']; else $this->direction = "in";
		$this->shift		= (string)$xml['shift'];
		$this->min			= (int)$xml['min'];
		$this->max			= (int)$xml['max'];
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
		
		// group
		$att = $xml->createAttribute('group');
		$att->value = $this->group;
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
