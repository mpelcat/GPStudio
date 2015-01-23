<?php

require_once("block.php");

class IO extends Block
{
	function __construct($io_device_element, $io_node_element=null)
	{
		parent::__construct();
		if(get_class($io_device_element)==='SimpleXMLElement')
		{
			$io_name = (string)$io_device_element['name'];
			$this->name = $io_name;
			$io_driver = (string)$io_device_element['driver'];
		
			// add io file to the list of files
			$file_config = new File();
			$file_config->name = $io_driver . ".io";
			$file_config->path = $io_driver . ".io";
			array_push($this->files, $file_config);
		
			$this->path = LIB_PATH . "io" . DIRECTORY_SEPARATOR . $io_driver . DIRECTORY_SEPARATOR;
			$this->in_lib=true;
			$io_file = $this->path . $io_driver . ".io";
			
		}
		else
		{
			$io_file = $io_device_element;
		}
		
		if (!file_exists($io_file)){echo "File $io_file doesn't exist\n";return;}
		if (!($this->xml = simplexml_load_file($io_file))){echo "Error when parsing $io_file \n";return;}
	
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
				array_push($this->ext_ports, new Port($port));
			}
		}
		
		// pins assignement
		if(isset($io_device_element->pins))
		{
			foreach($io_device_element->pins->pin as $pin)
			{
				array_push($this->pins, new Pin($pin));
			}
		}
	}
}

?>
