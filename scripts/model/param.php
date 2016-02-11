<?php

require_once("parambitfield.php");

class Param
{
	/**
	* Name of the param
	* @var string $name
	*/
	public $name;

	/**
	* 
	* @var string $type
	*/
	public $type;

	/**
	* Relative adress of the param
	* @var int $regaddr
	*/
	public $regaddr;

	/**
	* Current value of the param
	* @var string $value
	*/
	public $value;

	/**
	* Default value of the param
	* @var string $default
	*/
	public $default;

	/**
	* Minimum value of the param
	* @var string $min
	*/
	public $min;

	/**
	* Maximum value of the param
	* @var string $max
	*/
	public $max;

	/**
	* Generic parameter (hard = true) or dynamic one (hard = false)
	* @var bool $hard
	*/
	public $hard;

	/**
	* Mapping to properties (optional)
	* @var string $propertymap
	*/
	public $propertymap;

	/**
	* Description of the param (optional)
	* @var string $desc
	*/
	public $desc;

	/**
	* Reference to the associated parent block
	* @var Block $parentBlock
	*/
	public $parentBlock;

	
	/**
	* Array of bitfields if param contain different bitfield (optional)
	* @var array|ParamBitfield $parambitfields
	*/
	public $parambitfields;
	
	function __construct($xml=null)
	{
		$this->parentBlock = null;
		$this->parambitfields	= array();
		$this->paramenums		= array();
		if($xml) $this->parse_xml($xml);
	}
	
	public function __toString()
    {
		if($this->hard) return "constant ".$this->name." type: ".$this->type." value: ".$this->value;
		else return "register ".$this->name." regaddr: ".$this->regaddr." propertymap: '".$this->propertymap."'";
    }
    
    public static function cmp_raddr($a, $b)
    {
		if($a->hard && $b->hard) return 0;
		if($a->hard) return -1;
		if($b->hard) return 1;
		if ($a->regaddr == $b->regaddr) return 0;
		return ($a->regaddr < $b->regaddr) ? -1 : 1;
	}
	
	protected function parse_xml($xml)
	{
		$this->name			= (string)$xml['name'];
		$this->type			= (string)$xml['type'];
		$this->regaddr		= (string)$xml['regaddr'];
		$this->value		= (string)$xml['value'];
		$this->default		= (string)$xml['default'];
		$this->min			= (string)$xml['min'];
		$this->max			= (string)$xml['max'];
		$this->propertymap	= (string)$xml['propertymap'];
		$this->desc			= (string)$xml['desc'];
		
		if((string)$xml['hard']=="1" or (string)$xml['hard']=="true") $this->hard=true; else $this->hard=false;
		
		// parambitfields
		if(isset($xml->bitfields))
		{
			foreach($xml->bitfields->bitfield as $bitfield)
			{
				$this->addParamBitfield(new ParamBitfield($bitfield));
			}
		}
		
		// enums
		if(isset($xml->enums))
		{
			foreach($xml->enums->enum as $enum)
			{
				array_push($this->paramenums, new ParamEnum($enum));
			}
		}
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("param");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// value
		$att = $xml->createAttribute('value');
		$att->value = $this->value;
		$xml_element->appendChild($att);
		
		if($format=="complete" or $format=="blockdef")
		{
			if($this->hard)
			{
				// type
				$att = $xml->createAttribute('type');
				$att->value = $this->type;
				$xml_element->appendChild($att);
			
				// hard
				$att = $xml->createAttribute('hard');
				$att->value = $this->hard;
				$xml_element->appendChild($att);
			}
			else
			{
				// regaddr
				$att = $xml->createAttribute('regaddr');
				$att->value = $this->regaddr;
				$xml_element->appendChild($att);
			
				// propertymap
				$att = $xml->createAttribute('propertymap');
				$att->value = $this->propertymap;
				$xml_element->appendChild($att);
			}
			
			// default
			$att = $xml->createAttribute('default');
			$att->value = $this->default;
			$xml_element->appendChild($att);
			
			// min
			$att = $xml->createAttribute('min');
			$att->value = $this->min;
			$xml_element->appendChild($att);
			
			// max
			$att = $xml->createAttribute('max');
			$att->value = $this->max;
			$xml_element->appendChild($att);
			
			// desc
			$att = $xml->createAttribute('desc');
			$att->value = $this->desc;
			$xml_element->appendChild($att);
			
			// parambitfields
			if(!empty($this->parambitfields))
			{
				$xml_parambitfields = $xml->createElement("bitfields");
				foreach($this->parambitfields as $parambitfield)
				{
					$xml_parambitfields->appendChild($parambitfield->getXmlElement($xml, $format));
				}
				$xml_element->appendChild($xml_parambitfields);
			}
		}
		
		return $xml_element;
	}
	
	/** Add a parambitfield to the param 
	 *  @param ParamBitfield $parambitfield parambitfield to add to the param **/
	function addParamBitfield($parambitfield)
	{
		$parambitfield->parentParam = $this;
		array_push($this->parambitfields, $parambitfield);
	}
	
	/** return a reference to the bitfield with the name $name, if not found, return null
	 *  @param string $name name of the parambitfield to search
	 *  @param bool $casesens take care or not of the case of the name
	 *  @return ParamBitfield found bitfield **/
	function getParambitfield($name, $casesens=true)
	{
		if($casesens)
		{
			foreach($this->parambitfields as $parambitfield)
			{
				if($parambitfield->name==$name) return $parambitfield;
			}
		}
		else
		{
			foreach($this->parambitfields as $parambitfield)
			{
				if(strcasecmp($parambitfield->name,$name)==0) return $parambitfield;
			}
		}
		return null;
	}
	
	/** delete a bitfield from his name
	 *  @param string $name name of the bitfield to delete **/
	function delParambitfield($name)
	{
		$i=0;
		foreach($this->parambitfields as $parambitfield)
		{
			if($parambitfield->name==$name) {unset($this->parambitfields[$i]); return;}
			$i++;
		}
		return null;
	}
}

?>
