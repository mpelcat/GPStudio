<?php

class Port
{
	public $name;
	public $type;
	public $size;
	public $desc;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->type		= (string)$xml['type'];
		$this->size		= (int)$xml['size'];
		$this->desc		= (string)$xml['desc'];
	}
}

?>
