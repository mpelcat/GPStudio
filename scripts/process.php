<?php

require_once("block.php");

class Process extends Block
{
	function __construct($process_node_element)
	{
		parent::__construct();
		/*$process_file = LIB_PATH . "process" . DIRECTORY_SEPARATOR . $io_driver . DIRECTORY_SEPARATOR . $process_driver . ".io";
		if (!file_exists($process_file)){echo "File $process_file doesn't exist\n";return;}
		if (!($this->xml = simplexml_load_file($node_file))){echo "Error when parsing $process_file \n";return;}*/
		
		$this->parse_xml($process_node_element);
		unset($this->xml);
	}
	
	protected function parse_xml($process_node_element)
	{
		$this->xml = $process_node_element;
		$this->name = (string)$process_node_element['name'];
		parent::parse_xml();
	}
}

?>
