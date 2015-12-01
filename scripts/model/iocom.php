<?php

require_once("io.php");
require_once("comconnect.php");

class IOCom extends IO
{
	/**
	* Name of the driver to use for etablish a communication with the board
	* @var string $driverio
	*/
	public $driverio;
	

	/**
	* Array of ComConnect to give the equivalence table between hardware flow and software id flow
	* @var array|ComConnect $com_connects
	*/
	public $comConnects;
	
	function __construct($io_device_element, $io_node_element=null)
	{
		$this->comConnects = array();
		
		parent::__construct($io_device_element, $io_node_element);
	}
	
	protected function parse_xml($io_device_element, $io_node_element)
	{
		parent::parse_xml($io_device_element, $io_node_element);
		
		if(isset($this->xml->com_connects))
		{
			$this->driverio	= (string)$this->xml->com_connects['driverio'];
			
			// com_connects
			if(isset($this->xml->com_connects))
			{
				foreach($this->xml->com_connects->com_connect as $com_connectXml)
				{
					$this->addComConnect(new ComConnect($com_connectXml));
				}
			}
		}
	}
	
	public function type() {return 'iocom';}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = parent::getXmlElement($xml, $format);
		
		if($format=="complete")
		{
			// com_connects
			$xml_com_connects = $xml->createElement("com_connects");
			
			//driverio
			$att = $xml->createAttribute('driverio');
			$att->value = $this->driverio;
			$xml_com_connects->appendChild($att);
			
			foreach($this->comConnects as $comConnect)
			{
				$xml_com_connects->appendChild($comConnect->getXmlElement($xml, $format));
			}
			$xml_element->appendChild($xml_com_connects);
		}
		
		return $xml_element;
	}
	
	/** Add a comConnect to the comParam 
	 *  @param ComConnect $comConnect comConnect to add to the comParam **/
	function addComConnect($comConnect)
	{
		array_push($this->comConnects, $comConnect);
	}
	
	/** return a reference to the comConnect with the link $link, if not found, return null
	 *  @param string $link link of the comConnect to search
	 *  @return ComConnect found comConnect **/
	function getComConnect($link)
	{
		foreach($this->comConnects as $comConnect)
		{
			if($comConnect->link==$link) return $file;
		}
		return null;
	}
}
