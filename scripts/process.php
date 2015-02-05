<?php

require_once("block.php");

class Process extends Block
{
	function __construct($process_node_element)
	{
		parent::__construct();
		
		if(get_class($process_node_element)==='SimpleXMLElement')
		{
			$inlib=true;
			
			if(isset($process_node_element['inlib']))
			{
				if($process_node_element['inlib']=='false') $inlib=false;
			}
			if(isset($process_node_element['type']))
			{
				$inlib=true;
				$this->driver = (string)$process_node_element['type'];
			}
			
			if(!isset($process_node_element['name'])) $this->name = $this->driver;
			else $this->name = (string)$process_node_element['name'];
			
			$this->in_lib = $inlib;
			if($this->in_lib)
			{
				if(!isset($this->driver)) $this->driver=$this->name;
				
				$this->path = LIB_PATH . "process" . DIRECTORY_SEPARATOR . $this->driver . DIRECTORY_SEPARATOR;
				$process_file = $this->path . $this->driver . '.proc';
				
				if (!file_exists($process_file)){echo "File $process_file doesn't exist\n";return;}
				if (!($this->xml = simplexml_load_file($process_file))){echo "Error when parsing $process_file \n";return;}
				
				$this->parse_xml($this->xml);
			}
			else
			{
				$this->parse_xml($process_node_element);
			}
		}
		else
		{
			$process_file = $process_node_element;
			
			if (!file_exists($process_file)){echo "File $process_file doesn't exist\n";return;}
			if (!($this->xml = simplexml_load_file($process_file))){echo "Error when parsing $process_file \n";return;}
			
			$this->parse_xml($this->xml);
		}
		
		unset($this->xml);
	}
	
	protected function parse_xml($process_node_element)
	{
		$this->xml = $process_node_element;
		parent::parse_xml();
	}
}

?>
