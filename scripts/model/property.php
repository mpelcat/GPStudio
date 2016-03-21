<?php

/* 
 * Copyright (C) 2014 Dream IP
 * 
 * This file is part of GPStudio.
 *
 * GPStudio is a free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
	* Mapping to properties (optional)
	* @var string $propertymap
	*/
	public $propertymap;

	/**
	* Code to execute if the property change (optional)
	* @var string $onchange
	*/
	public $onchange;

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

	/**
	* Reference to the associated parent block (don't set if parentProperty is set)
	* @var Block $parentBlock
	*/
	public $parentBlock;

	/**
	* Reference to the associated parent Property (don't set if parentBlock is set)
	* @var Property $parentProperty
	*/
	public $parentProperty;
	
	function __construct($xml=null)
	{
		$this->parentBlock = null;
		$this->parentProperty = null;
		$this->propertyenums	= array();
		$this->properties		= array();
		if($xml) $this->parse_xml($xml);
	}
	
	public function __toString()
    {
        $string=$this->name." caption:'".$this->caption."' type:'".$this->type."' value:'".$this->value."' min:'".$this->min."' max:'".$this->max."' step:'".$this->step."' desc:'".$this->desc."'";
        return $string;
    }
	
	protected function parse_xml($xml)
	{
		$this->name			= (string)$xml['name'];
		if(strpos($this->name, '.')!==false) error("Property name cannot contains . (dot) in \"$this->name\"",5,"Property");
		$this->caption		= (string)$xml['caption'];
		$this->type			= (string)$xml['type'];
		$this->value		= (string)$xml['value'];
		$this->min			= (string)$xml['min'];
		$this->max			= (string)$xml['max'];
		$this->step			= (string)$xml['step'];
		$this->assert		= (string)$xml['assert'];
		$this->propertymap	= (string)$xml['propertymap'];
		$this->onchange		= (string)$xml['onchange'];
		$this->desc			= (string)$xml['desc'];
		
		// enums
		if(isset($xml->enums))
		{
			foreach($xml->enums->enum as $enumXml)
			{
				$this->addPropertyEnum(new PropertyEnum($enumXml));
			}
		}
		
		// properties
		if(isset($xml->properties))
		{
			foreach($xml->properties->property as $propertyXml)
			{
				$this->addSubProperty(new Property($propertyXml));
			}
		}
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("property");
		
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
			
			// type
			$att = $xml->createAttribute('type');
			$att->value = $this->type;
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
			
			// propertymap
			$att = $xml->createAttribute('propertymap');
			$att->value = $this->propertymap;
			$xml_element->appendChild($att);
			
			// onchange
			$att = $xml->createAttribute('onchange');
			$att->value = $this->onchange;
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
					$xml_propertyenums->appendChild($property->getXmlElement($xml, $format));
				}
				$xml_element->appendChild($xml_propertyenums);
			}
		}
		
		// properties
		if(!empty($this->properties))
		{
			$xml_property = $xml->createElement("properties");
			foreach($this->properties as $property)
			{
				$xml_property->appendChild($property->getXmlElement($xml, $format));
			}
			$xml_element->appendChild($xml_property);
		}
		
		return $xml_element;
	}
	
	/** Add a property enum to the block 
	 *  @param PropertyEnum $propertyenum property enum to add to the property **/
	function addPropertyEnum($propertyenum)
	{
		$propertyenum->parentProperty = $this;
		array_push($this->propertyenums, $propertyenum);
	}
	
	/** return a reference to the property enum with the name $name, if not found, return false
	 *  @param string $name name of the property enum to search
	 *  @param bool $casesens take care or not of the case of the name
	 *  @return PropertyEnum found property enum **/
	function getPropertyEnum($name, $casesens=true)
	{
		if($casesens)
		{
			foreach($this->propertyenums as $propertyenum)
			{
				if($propertyenum->name==$name) return $propertyenum;
			}
		}
		else
		{
			foreach($this->propertyenums as $propertyenum)
			{
				if(strcasecmp($propertyenum->name,$name)==0) return $propertyenum;
			}
		}
		return null;
	}
	
	/** delete a property enum from his name
	 *  @param string $name name of the property enum to delete  **/
	function delPropertyEnum($name)
	{
		$i=0;
		foreach($this->propertyenums as $propertyenum)
		{
			if($propertyenum->name==$name) {unset($this->propertyenums[$i]); return;}
			$i++;
		}
	}
	
	/** Add a sub-property to the property 
	 *  @param Property $property sub-property to add to the property **/
	function addSubProperty($property)
	{
		$property->parentProperty = $this;
		array_push($this->properties, $property);
	}
	
	/** alias to addSubProperty($property)
	 *  @param Property $property sub-property to add to the property **/
	function addProperty($property)
	{
		$this->addSubProperty($property);
	}
	
	/** return a reference to the property with the name $name, if not found, return false
	 *  @param string $name name of the property enum to search
	 *  @param bool $casesens take care or not of the case of the name
	 *  @return Property found property **/
	function getSubProperty($name, $casesens=true)
	{
		if($casesens)
		{
			foreach($this->properties as $property)
			{
				if($property->name==$name) return $property;
			}
		}
		else
		{
			foreach($this->properties as $property)
			{
				if(strcasecmp($property->name,$name)==0) return $property;
			}
		}
		return null;
	}
	
	/** alias to getSubProperty($name, $casesens)
	 *  @param string $name name of the property enum to search
	 *  @param bool $casesens take care or not of the case of the name
	 *  @return Property found property **/
	function getProperty($name, $casesens=true)
	{
		return $this->getSubProperty($name, $casesens);
	}
	
	/** delete a property from his name
	 *  @param string $name name of the property to delete  **/
	function delSubProperty($name)
	{
		$i=0;
		foreach($this->properties as $property)
		{
			if($property->name==$name) {unset($this->properties[$i]); return;}
			$i++;
		}
	}
	
	/** alias to delSubProperty($name)
	 *  @param string $name name of the property to delete  **/
	function delProperty($name)
	{
		return $this->delSubProperty($name);
	}
	
	/** return the path of the property (without the name of the block)
	 *  @return string path of the property **/
	function path()
	{
		if($this->parentProperty==NULL) return $this->name;
		else return $this->parentProperty->path().".".$this->name;
	}
	
	function completePath()
	{
		if($this->parentProperty==NULL)
		{
			if(get_class($this->parentBlock)=="Flow") return $this->parentBlock->parentBlock->name.".".$this->parentBlock->name.".".$this->name;
			else return $this->parentBlock->name.".".$this->name;
		}
		else return $this->parentProperty->path().".".$this->name;
	}
	
	static function dependsProperties($expression)
	{
		preg_match_all("/([a-zA-Z_]+[a-zA-Z0-9_]*\\.?)+/x", $expression, $matches);
		$depends=array();
		foreach($matches[0] as $match)
		{
			if(substr($match,-6)===".value" or substr($match,-5)===".bits") array_push($depends, $match);
		}
		return array_unique($depends);
	}
	
	static function localToGlobalPropertyPath($expression, $blockName)
	{
		foreach(Property::dependsProperties($expression) as $depend)
		{
			$expression = str_replace($depend, $blockName .'.'. $depend, $expression);
		}
		return $expression;
	}
	
	function toGlobalPropertyPath($blockName)
	{
		$this->propertymap = Property::localToGlobalPropertyPath($this->propertymap, $blockName);
		$this->onchange = Property::localToGlobalPropertyPath($this->onchange, $blockName);
		
		foreach($this->properties as $property)
		{
			$property->toGlobalPropertyPath($blockName);
		}
	}
}

?>
