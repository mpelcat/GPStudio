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
	* Minimal value for this clock in Hz, could be written like this : 14.2M or 18.7k or 1500
	* @var float $min
	*/
	public $min;

	/**
	* Maximal value for this clock in Hz, could be written like this : 14.2M or 18.7k or 1500
	* @var float $max
	*/
	public $max;

	/**
	* Typical value for this clock in Hz, could be written like this : 14.2M or 18.7k or 1500
	* @var float $typical
	*/
	public $typical;

	/**
	* ratio compared to the main clock domain. If domain not set, produce an error. Default value 1.
	* @var float $ratio
	*/
	public $ratio;

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
		$this->shift = 0;
		$this->ratio = 1;
		$this->direction = "in";
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name	= (string)$xml['name'];
		$this->domain = "";
		if(isset($xml['direction'])) $this->direction = (string)$xml['direction']; else $this->direction = "in";
		
		if(isset($xml['typical']))
		{
			$this->typical = Clock::convert($xml['typical']);
		}
		elseif(isset($xml['min']) and isset($xml['max']))
		{
			$this->min = Clock::convert($xml['min']);
			$this->max = Clock::convert($xml['max']);
		}
		elseif(isset($xml['domain']))
		{
			$this->domain = (string)$xml['domain'];
			if(isset($xml['ratio'])) $this->ratio = (float)$xml['ratio']; else $this->ratio = 1;
		}
		else
		{
			error('Clock settings error, no possibilities to find the good configuration.',20);
		}
		
		if(isset($xml['shift']) and (int)$xml['shift']!=0)
		{
			if(!isset($xml['domain']) or empty($xml['domain'])) warning('Clock shift without domain have no sense, you should set a domain',20);
			$this->shift = (int)$xml['shift'];
		}
		else $this->shift = 0;
		
		$this->desc = (string)$xml['desc'];
	}
	
	public static function convert($string)
	{
		$clock = (string)$string;
		$coef=1;
		if(stripos($clock, 'k'))     $coef=1000;
		elseif(stripos($clock, 'm')) $coef=1000000;
		elseif(stripos($clock, 'g')) $coef=1000000000;
		$clock = preg_replace('|[ kmgKMG]|','',$clock);
		$clock = (float)$clock * $coef;
		return $clock;
	}
	
	static function formatFreq($freq)
	{
		if($freq>=1000000000)
		{
			return (floor($freq/1000000)/1000).' GHz';
		}
		elseif($freq>=1000000)
		{
			return (floor($freq/1000)/1000).' MHz';
		}
		elseif($freq>=1000)
		{
			return ($freq/1000).' kHz';
		}
		else
		{
			return $freq.' Hz';
		}
	}
	
	static function hdlFreq($freq)
	{
		if($freq>=1000000000)
		{
			return preg_replace('|[\.,]|','_',(floor($freq/1000000)/1000).'G');
		}
		elseif($freq>=1000000)
		{
			return preg_replace('|[\.,]|','_',(floor($freq/1000)/1000).'M');
		}
		elseif($freq>=1000)
		{
			return preg_replace('|[\.,]|','_',($freq/1000).'k');
		}
		else
		{
			return $freq;
		}
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
		
		// ratio
		$att = $xml->createAttribute('ratio');
		$att->value = $this->ratio;
		$xml_element->appendChild($att);
		
		// desc
		$att = $xml->createAttribute('desc');
		$att->value = $this->desc;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
