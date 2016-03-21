<?php

/* 
 * Copyright (C) 2016 Dream IP
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

require_once("block.php");

class IO extends Block
{
	/**
	* External pins mapping for blocks abble to comunicate with the output
	* @var array|Pin $pins
	*/
	public $pins;

	/**
	* Array of port abble to comunicate with the output
	* @var array|Port $ext_ports
	*/
	public $ext_ports;
	
	function __construct($io_device_element=null, $io_node_element=null)
	{
		$this->pins = array();
		$this->ext_ports = array();
		
		parent::__construct();
		
		if(is_object($io_device_element) and get_class($io_device_element)==='SimpleXMLElement')
		{
			$io_name = (string)$io_device_element['name'];
			$this->name = $io_name;
			$io_driver = (string)$io_device_element['driver'];
			
			if(isset($io_node_element['x_pos'])) $this->x_pos = (int)$io_node_element['x_pos'];
			if(isset($io_node_element['y_pos'])) $this->y_pos = (int)$io_node_element['y_pos'];
		
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
		elseif(is_string($io_device_element))
		{
			if(substr($io_device_element,-3)===".io")
			{
				$io_file = $io_device_element;
				$this->name = str_replace(".io","",basename($io_file));
				$this->driver = $this->name;
				$this->path = realpath(dirname($io_file));
			}
			elseif(strpos($io_device_element, "/")===false and strpos($io_device_element, "\\")===false)
			{
				$io_name = $io_device_element;
				$io_driver = $io_node_element;
				$this->name = $io_name;
				$this->driver = $io_driver;
				$this->path = SUPPORT_PATH . "io" . DIRECTORY_SEPARATOR . $io_driver . DIRECTORY_SEPARATOR;
				$this->in_lib=true;
				$io_file = $this->path . $io_driver . ".io";
			}
			else
			{
				$io_file = $io_device_element;
				$this->path = realpath(dirname($io_file));
			}
		}
		
		if($io_device_element!=NULL)
		{
			if(!file_exists($io_file)) error("File $io_file doesn't exist",5,"IO");
			if(!($this->xml = simplexml_load_file($io_file))) error("Error when parsing $io_file",5,"IO");
	
			$this->parse_xml($io_device_element, $io_node_element);
		}
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
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = parent::getXmlElement($xml, $format);
		
		if($format=="complete" or $format=="blockdef")
		{
			// ports
			$xml_ports = $xml->createElement("ports");
			foreach($this->ext_ports as $port)
			{
				$xml_ports->appendChild($port->getXmlElement($xml, $format));
			}
			$xml_element->appendChild($xml_ports);
			
			// pins
			$xml_pins = $xml->createElement("pins");
			foreach($this->pins as $pin)
			{
				$xml_pins->appendChild($pin->getXmlElement($xml, $format));
			}
			$xml_element->appendChild($xml_pins);
		}
		
		return $xml_element;
	}
	
	/** Add a pin to the block 
	 *  @param Pin $pin pin to add to the block **/
	function addPin($pin)
	{
		$pin->parentBlock = $this;
		array_push($this->pins, $pin);
	}
	
	/** return a reference to the pin with the name $name, if not found, return null
	 *  @param string $name name of the pin to search
	 *  @param bool $casesens take care or not of the case of the name
	 *  @return Pin found pin **/
	function getPin($name, $casesens=true)
	{
		if($casesens)
		{
			foreach($this->pins as $pin)
			{
				if($pin->name==$name) return $pin;
			}
		}
		else
		{
			foreach($this->pins as $pin)
			{
				if(strcasecmp($pin->name,$name)==0) return $pin;
			}
		}
		return null;
	}
	
	/** Add an external port to the block 
	 *  @param Port $extPort port to add to the block **/
	function addExtPort($extPort)
	{
		$extPort->parentBlock = $this;
		array_push($this->ext_ports, $extPort);
	}
	
	/** return a reference to the external port with the name $name, if not found, return null
	 *  @param string $name name of the external port to search
	 *  @param bool $casesens take care or not of the case of the name
	 *  @return Port found external port **/
	function getExtPort($name, $casesens=true)
	{
		if($casesens)
		{
			foreach($this->ext_ports as $extPort)
			{
				if($extPort->name==$name) return $extPort;
			}
		}
		else
		{
			foreach($this->ext_ports as $extPort)
			{
				if(strcasecmp($extPort->name,$name)==0) return $extPort;
			}
		}
		return null;
	}
	
	/** delete an external port from his name
	 *  @param string $name name of the external port to delete  **/
	function delExtPort($name)
	{
		$i=0;
		foreach($this->ext_ports as $ext_port)
		{
			if($ext_port->name==$name) {unset($this->ext_ports[$i]); return;}
			$i++;
		}
		return null;
	}
}

?>
