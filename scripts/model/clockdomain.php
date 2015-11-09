<?php

/** 
 * ClockDomain permits to save typical frequency of a clock domain.
 * @brief ClockDomain permits to save typical frequency of a clock domain.
 * @see Clock ClockInterconnect
 * @ingroup base
 */

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
