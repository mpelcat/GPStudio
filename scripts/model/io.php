<?php

require_once("block.php");

class IO extends Block
{
	function __construct($io_device_element, $io_node_element=null)
	{
		parent::__construct();
		if(is_object($io_device_element) and get_class($io_device_element)==='SimpleXMLElement')
		{
			$io_name = (string)$io_device_element['name'];
			$this->name = $io_name;
			$io_driver = (string)$io_device_element['driver'];
		
			// add io file to the list of files
			$file_config = new File();
			$file_config->name = $io_driver . ".io";
			$file_config->path = $io_driver . ".io";
			$file_config->parentBlock = $this;
			$this->addFile($file_config);
		
			$this->path = SUPPORT_PATH . "io" . DIRECTORY_SEPARATOR . $io_driver . DIRECTORY_SEPARATOR;
			$this->in_lib=true;
			$io_file = $this->path . $io_driver . ".io";
		}
		else
		{
			$io_file = $io_device_element;
			$this->path = realpath(dirname($io_file));
		}
		
		if (!file_exists($io_file)) error("File $io_file doesn't exist",5,"IO");
		if (!($this->xml = simplexml_load_file($io_file))) error("Error when parsing $io_file",5,"IO");
	
		$this->parse_xml($io_device_element, $io_node_element);
		unset($this->xml);
	}
	
	protected function parse_xml($io_device_element, $io_node_element)
	{
		parent::parse_xml();
		$this->driver = (string)$this->xml['driver'];
		$this->master_count = (int)$this->xml['master_count'];
		
		// ports
		if(isset($this->xml->ports))
		{
			foreach($this->xml->ports->port as $port)
			{
				$this->addExtPort(new Port($port));
			}
		}
		
		// pins assignement
		if(isset($io_device_element->pins))
		{
			foreach($io_device_element->pins->pin as $pin)
			{
				$this->addPin(new Pin($pin));
			}
		}
	}
	
	public function type() {return 'io';}
	
	public function getXmlElement($xml)
	{
		$xml_element = parent::getXmlElement($xml);
		
		// ports
		$xml_ports = $xml->createElement("ports");
		foreach($this->ext_ports as $port)
		{
			$xml_ports->appendChild($port->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_ports);
		
		// pins
		$xml_pins = $xml->createElement("pins");
		foreach($this->pins as $pin)
		{
			$xml_pins->appendChild($pin->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_pins);
		
		return $xml_element;
	}
}

?>
