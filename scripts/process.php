<?php

require_once("block.php");

class Process extends Block
{
	function __construct($process_node_element)
	{
		parent::__construct();
		
		if(is_object($process_node_element) and get_class($process_node_element)==='SimpleXMLElement')
		{
			$inlib=false;
			
			if(isset($process_node_element['inlib']))
			{
				if($process_node_element['inlib']=='false') $inlib=false; else $inlib=true;
			}
			if(isset($process_node_element['driver'])) $this->driver = (string)$process_node_element['driver'];
			else $this->driver = (string)$process_node_element['name'];
			
			if(!isset($process_node_element['name'])) $this->name = $this->driver;
			else $this->name = (string)$process_node_element['name'];
			
			$this->in_lib = $inlib;
			if($this->in_lib)
			{
				// process defined in library
				if(!isset($this->driver)) $this->driver=$this->name;
				
				$this->path = LIB_PATH . "process" . DIRECTORY_SEPARATOR . $this->driver . DIRECTORY_SEPARATOR;
				$process_file = $this->path . $this->driver . '.proc';
				
				if (!file_exists($process_file)) error("File $process_file doesn't exist",5,"Process");
				if (!($this->xml = simplexml_load_file($process_file))) error("Error when parsing $process_file",5,"Process");
				
				$this->parse_xml($this->xml);
			}
			else
			{
				if(!isset($process_node_element['files']))
				{
					// process defined in external .proc local to the projet
					if(isset($process_node_element['path']))
					{
						$this->path = getcwd() . DIRECTORY_SEPARATOR . (string)$process_node_element['path'];
					}
					else
					{
						$this->path = getcwd() . DIRECTORY_SEPARATOR;
					}
					
					$process_file = $this->path . $this->driver . '.proc';
					echo $process_file."\n";
				
					if (!file_exists($process_file)) error("File $process_file doesn't exist",5,"Process");
					if (!($this->xml = simplexml_load_file($process_file))) error("Error when parsing $process_file",5,"Process");
					
					$this->parse_xml($this->xml);
				}
				else
				{
					// process defined inside .node
					$this->parse_xml($process_node_element);
				}
			}
		}
		else
		{
			$process_file = $process_node_element;
			
			if (!file_exists($process_file)) error("File $process_file doesn't exist",5,"Process");
			if (!($this->xml = simplexml_load_file($process_file))) error("Error when parsing $process_file",5,"Process");
			
			$this->parse_xml($this->xml);
			$this->path = realpath(dirname($process_node_element));
		}
		
		unset($this->xml);
	}
	
	protected function parse_xml($process_node_element)
	{
		$this->xml = $process_node_element;
		parent::parse_xml();
	}
	
	public function type() {return 'process';}
	
	public function getXmlElement($xml)
	{
		$xml_element = parent::getXmlElement($xml);
		
		return $xml_element;
	}
}

?>
