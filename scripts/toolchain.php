<?php

require_once("attribute.php");

class Toolchain
{
	/**
	* Array of attributes of the pin (optional)
	* @var array|Attribute $attributes
	*/
	public $attributes;
	
	function __construct($xml=null)
	{
		$this->attributes = array();
		
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		
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
		$xml_element = $xml->createElement("toolchain");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
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
	
	public function configure_project($node)
	{
	}
	
	public function generate_project($node, $path)
	{
	}
	
	static public function load($toolchain_name)
	{
		switch ($toolchain_name)
		{
			case 'hdl':
				require("toolchain/hdl/hdl.php");
				return new HDL_toolchain();
				break;
			case 'altera_quartus':
				require("toolchain/altera_quartus/altera_quartus.php");
				return new Altera_quartus_toolchain();
				break;
			default:
				throw new Exception ('Toolchain \''.$toolchain_name.'\' doesn\'t exists.');
      }
	}
}

?>
