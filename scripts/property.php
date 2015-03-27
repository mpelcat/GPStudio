<?php

require_once("propertyenum.php");

class Property
{
	/**
	* Name of the property
	* @var string $name
	*/
	public $name;
	
	/**
	* Caption of the property for high level interface
	* @var string $caption
	*/
	public $caption;

	/**
	* Type of property
	* @var string $type
	*/
	public $type;

	/**
	* Current value of the property
	* @var string $value
	*/
	public $value;

	/**
	* Minimum value of the property
	* @var string $min
	*/
	public $min;

	/**
	* Maximum value of the property
	* @var string $max
	*/
	public $max;

	/**
	* Step value of the property
	* @var string $step
	*/
	public $step;

	/**
	* Check if the property is good (optional)
	* @var string $assert
	*/
	public $assert;

	/**
	* Description of the param (optional)
	* @var string $desc
	*/
	public $desc;
	

	/**
	* Array of enums if param property have different enums (optional)
	* @var array|PropertyEnum $propertyenums
	*/
	public $propertyenums;
	
	/**
	* Array of property class specify the high level properties
	* @var array|Property $properties
	*/
	public $properties;
	
	function __construct($xml=null)
	{
		$this->propertyenums	= array();
		$this->properties		= array();
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name			= (string)$xml['name'];
		$this->caption		= (string)$xml['caption'];
		$this->type			= (string)$xml['type'];
		$this->value		= (string)$xml['value'];
		$this->min			= (string)$xml['min'];
		$this->max			= (string)$xml['max'];
		$this->step			= (string)$xml['step'];
		$this->assert		= (string)$xml['assert'];
		$this->desc			= (string)$xml['desc'];
		
		// enums
		if(isset($xml->enums))
		{
			foreach($xml->enums->enum as $enum)
			{
				array_push($this->propertyenums, new PropertyEnum($enum));
			}
		}
		
		// properties
		if(isset($xml->properties))
		{
			foreach($xml->properties->property as $property)
			{
				array_push($this->properties, new Property($property));
			}
		}
	}
	
	public function getXmlElement($xml)
	{
		$xml_element = $xml->createElement("property");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// caption
		$att = $xml->createAttribute('caption');
		$att->value = $this->caption;
		$xml_element->appendChild($att);
		
		// type
		$att = $xml->createAttribute('type');
		$att->value = $this->type;
		$xml_element->appendChild($att);
		
		// value
		$att = $xml->createAttribute('value');
		$att->value = $this->value;
		$xml_element->appendChild($att);
		
		// min
		$att = $xml->createAttribute('min');
		$att->value = $this->min;
		$xml_element->appendChild($att);
		
		// max
		$att = $xml->createAttribute('max');
		$att->value = $this->max;
		$xml_element->appendChild($att);
		
		// step
		$att = $xml->createAttribute('step');
		$att->value = $this->step;
		$xml_element->appendChild($att);
		
		// assert
		$att = $xml->createAttribute('assert');
		$att->value = $this->assert;
		$xml_element->appendChild($att);
		
		// desc
		$att = $xml->createAttribute('desc');
		$att->value = $this->desc;
		$xml_element->appendChild($att);
		
		// propertyenums
		if(!empty($this->propertyenums))
		{
			$xml_propertyenums = $xml->createElement("enums");
			foreach($this->propertyenums as $property)
			{
				$xml_propertyenums->appendChild($property->getXmlElement($xml));
			}
			$xml_element->appendChild($xml_propertyenums);
		}
		
		// properties
		if(!empty($this->properties))
		{
			$xml_property = $xml->createElement("properties");
			foreach($this->properties as $property)
			{
				$xml_property->appendChild($property->getXmlElement($xml));
			}
			$xml_element->appendChild($xml_property);
		}
		
		return $xml_element;
	}
	
	function getPropertyEnum($name)
	{
		foreach($this->propertyenums as $propertyenum)
		{
			if($propertyenum->name==$name) return $propertyenum;
		}
		return null;
	}
	
	function getProperty($name)
	{
		foreach($this->properties as $property)
		{
			if($property->name==$name) return $property;
		}
		return null;
	}
}

?>
