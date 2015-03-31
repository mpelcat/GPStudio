<?php

class Pin
{
	/**
	* Pin name to map
	* @var string $name
	*/
	public $name;
	
	/**
	* Name of the external pin to map
	* @var string $mapto
	*/
	public $mapto;
	
	/**
	* Array of attributes of the pin (optional)
	* @var array|Attribute $attributes
	*/
	public $attributes;

	/**
	* Reference to the associated parent block
	* @var Block $parentBlock
	*/
	public $parentBlock;
	
	function __construct($xml=null)
	{
		$this->parentBlock = null;
		$this->attributes = array();
		
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->mapto	= (string)$xml['mapto'];
		
		// attributes
		if(isset($xml->attributes))
		{
			foreach($xml->attributes->attribute as $attribute)
			{
				array_push($this->attributes, new Attribute($attribute));
			}
		}
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
		
		// attributes
		if(!empty($this->attributes))
		{
			$xml_attributes = $xml->createElement("attributes");
			foreach($this->attributes as $attribute)
			{
				$xml_attributes->appendChild($attribute->getXmlElement($xml));
			}
			$xml_element->appendChild($xml_attributes);
		}
		
		return $xml_element;
	}
}

?>
