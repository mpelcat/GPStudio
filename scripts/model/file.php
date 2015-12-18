<?php

/** 
 * File are stored in Block::files as a list.
 * @brief Model class to have informations about file implementation in a Block.
 * @see Block
 * @ingroup base
 */

class File
{
	/**
	* Name of the file
	* @var string $name
	*/
	public $name;

	/**
	* File type can be : ['', 'verilog', 'vhdl', 'qip', 'sdc', 'hex']
	* @var string $type
	*/
	public $type;

	/**
	* Group can be : ['', 'hdl', ...]
	* @var string $group
	*/
	public $group;

	/**
	* Sub path of the file
	* @var string $path
	*/
	public $path;

	/**
	* True if this file is generated, so the path is not modified by the toolchain
	* @var bool $generated
	*/
	public $generated;

	/**
	* Description of the file (optional)
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
		$this->generated = false;
		if($xml) $this->parse_xml($xml);
	}
	
	public function __toString()
    {
        return "'".$this->path."' type: '".$this->type."' group: '".$this->group."' desc: '".$this->desc."'";
    }
	
	protected function parse_xml($xml)
	{
		$this->name = (string)$xml['name'];
		$this->type = (string)$xml['type'];
		$this->group = (string)$xml['group'];
		$this->path = (string)$xml['path'];
		$this->desc = (string)$xml['desc'];
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("file");
		
		// name
		$att = $xml->createAttribute('name');
		$att->value = $this->name;
		$xml_element->appendChild($att);
		
		// type
		$att = $xml->createAttribute('type');
		$att->value = $this->type;
		$xml_element->appendChild($att);
		
		// group
		$att = $xml->createAttribute('group');
		$att->value = $this->group;
		$xml_element->appendChild($att);
		
		// path
		$att = $xml->createAttribute('path');
		$att->value = $this->path;
		$xml_element->appendChild($att);
		
		// desc
		$att = $xml->createAttribute('desc');
		$att->value = $this->desc;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
