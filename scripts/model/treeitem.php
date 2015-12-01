<?php

class TreeItem
{
	/**
	* Name of the block source of the flow
	* @var string $fromblock
	*/
	public $fromblock;

	/**
	* Name of the flow on the block source of the flow
	* @var string $fromflow
	*/
	public $fromflow;

	/**
	* Size of connect in bit
	* @var string $size
	*/
	public $size;

	/**
	* Byte ordering can be "msb" or "lsb", default value is "msb"
	* @var string $order
	*/
	public $order;

	/**
	* Value of the property to choose this connexion
	* @var string $muxvalue
	*/
	public $muxvalue;
	
	function __construct($fromblock='', $fromflow='', $size=8, $order='msb', $muxvalue='')
	{
		$this->fromblock=$fromblock;
		$this->fromflow=$fromflow;
		$this->size=$size;
		$this->order=$order;
		$this->muxvalue=$muxvalue;
	}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = $xml->createElement("tree_connect");
		
		// fromblock
		$att = $xml->createAttribute('fromblock');
		$att->value = $this->fromblock;
		$xml_element->appendChild($att);
		
		// fromflow
		$att = $xml->createAttribute('fromflow');
		$att->value = $this->fromflow;
		$xml_element->appendChild($att);
		
		// size
		$att = $xml->createAttribute('size');
		$att->value = $this->size;
		$xml_element->appendChild($att);
		
		// order
		$att = $xml->createAttribute('order');
		$att->value = $this->order;
		$xml_element->appendChild($att);
		
		// muxvalue
		$att = $xml->createAttribute('muxvalue');
		$att->value = $this->muxvalue;
		$xml_element->appendChild($att);
		
		return $xml_element;
	}
}

?>
