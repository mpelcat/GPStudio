<?php

/** @brief The Clock class is used to define a clock source or a clock input in Block or Board
 * 
 * Clock instance is present in Board and Block.
 * 
 * It's possible to define a clock with 3 ways :
 * 	- Clock::$typical frequency and eventualy a clock Clock::$shift given in degrees
 * 	- an interval of frequency given with Clock::$min and Clock::$max
 * 	- a clock Clock::$domain and a Clock::$ratio
 * 
 * If typical is set, the clock is completly constrained. In other case, the typical freq is computed by the ClockInterconnect::configure() method.
 * 
 * @see ClockInterconnect ClockDomain
 * @ingroup base
 */

class Clock
{
	/** @brief name of the clock
	* 
	* This name should be unique in the block.
	* @var string $name
	*/
	public $name;

	/** @brief clock direction
	 * 
	* Specify if clock is in or out (value : "in" or "out", default "in")
	* @var string $direction
	*/
	public $direction;

	/** @brief clock shift phase
	* 
	* Phase shift of the clock given in degrees
	* @var int $shift
	*/
	public $shift;

	/** @brief minimum freq acceptance
	* 
	* Minimal value for this clock in Hz, could be written like this : 14.2M or 18.7k or 1500
	* @var float $min
	* @see $max
	*/
	public $min;

	/** @brief maximal freq acceptance
	* 
	* Maximal value for this clock in Hz, could be written like this : 14.2M or 18.7k or 1500
	* @var float $max
	* @see $min
	*/
	public $max;

	/** @brief frequence of the clock
	* 
	* Typical value for this clock in Hz, could be written like this : 14.2M or 18.7k or 1500. If this field is set, min, max and ratio was not used.
	* @var float $typical
	*/
	public $typical;

	/** @brief ratio frequence in the clock domain
	* 
	* ratio compared to the main clock domain. If domain not set, produce an error. Default value 1.
	* @var float $ratio
	* @see $domain
	*/
	public $ratio;

	/** @brief clock domain
	* 
	* Clocks in the same domain depend of the same clock source
	* @var string $domain
	*/
	public $domain;

	/** @brief net to connect the clock
	* 
	* Physical net name to connect the clock. This value is computed by CI
	* @var string $net
	* @see ClockInterconnect
	*/
	public $net;

	/** @brief description
	* 
	* Description of the clock (optional)
	* @var string $desc
	*/
	public $desc;

	/** @brief parent block
	* 
	* Reference to the associated parent block
	* @var Block $parentBlock
	*/
	public $parentBlock;
	

	/** @brief constructor
	* 
	* Initialise all the internal members and call parse_xml if $xml is set
	* @param SimpleXMLElement $xml if it's different of null, call the xml parser to fill members
	*/
	function __construct($xml=null)
	{
		$this->parentBlock = null;
		$this->shift = 0;
		$this->ratio = 1;
		$this->direction = "in";
		if($xml) $this->parse_xml($xml);
	}
	
	public function __toString()
    {
        return $this->name." ".Clock::formatFreq($this->typical)." ".$this->direction;
    }
	
	/** @brief private function to fill this instance from the input xml structure
	* 
	* Can be call only from this node into the constructor
	* @param SimpleXMLElement $xml xml element to parse
	*/
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
	
	/** @brief permit to output this instance
	* 
	* Return a formated node for the node_generated file. This method call all the children getXmlElement to add into this node.
	* @param DOMDocument $xml reference of the output xml document
	* @return DOMElement xml element corresponding to this current instance
	*/
	public function getXmlElement($xml, $format)
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
		
		if($format=="complete")
		{
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
			
			// ratio
			$att = $xml->createAttribute('ratio');
			$att->value = $this->ratio;
			$xml_element->appendChild($att);
			
			// desc
			$att = $xml->createAttribute('desc');
			$att->value = $this->desc;
			$xml_element->appendChild($att);
		}
		
		return $xml_element;
	}
	
	/** @brief frenquency from string
	* 
	* Return a frequency as number in Hz from a string. Input format can be : 14.2M or 18.7k or 1500
	* @param string $string string to convert to frequency in Hz
	* @return int frequency in Hz
	*/
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
	
	/** @brief human readable frequency
	* 
	* Return formated string of a frequency for human reader. This is used for printable report or warning.
	* @param int $freq frequency in Hz
	* @return string formated string
	*/
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
	
	/** @brief HDL readable frequency
	* 
	* Return formated string of a frequency for HDL compiler. This is used for naming convention in HDL output code.
	* @param int $freq frequency in Hz
	* @return string formated string
	*/
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
}

?>
