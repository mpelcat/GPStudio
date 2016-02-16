<?php

class PropertyEnum
{
	/**
	* Name of the enum
	* @var string $name
	*/
	public $name;
	
	/**
	* Caption of the property for high level interface (can contain space)
	* @var string $caption
	*/
	public $caption;

	/**
	* Coresponding value of the enum when this enum is chosen
	* @var string $value
	*/
	public $value;

	/**
	* Description of the enum (optional)
	* @var string $desc
	*/
	public $desc;

	/**
	* Reference to the associated parent Property
	* @var Property $parentProperty
	*/
	public $parentProperty;

	
	function __construct($xml=null)
	{
		$this->parentProperty = null;
		if($xml) $this->parse_xml($xml);
	}
	
	public function __toString()
    {
        $string=$this->name." caption:'".$this->caption."' value:'".$this->value."' desc:'".$this->desc."'";
        return $string;
    }
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->caption	= (string)$xml['caption'];
		if($this->caption=='') $this->caption = $this->name;
		$this->value	= (string)$xml['value'];
		$this->desc		= (string)$xml['desc'];
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("enum");
		
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
			// caption
			$att = $xml->createAttribute('caption');
			$att->value = $this->caption;
			$xml_element->appendChild($att);
		
			// desc
			$att = $xml->createAttribute('desc');
			$att->value = $this->desc;
			$xml_element->appendChild($att);
		}
		
		return $xml_element;
	}
}

?>
