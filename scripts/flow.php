<?php

class Flow
{
	public $name;
	public $type;
	public $desc;
	public $size;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name = (string)$xml['name'];
		$this->type = (string)$xml['type'];
		$this->desc = (string)$xml['desc'];
		if(!empty($xml['size'])) $this->size = (int)$xml['size']; else $this->size = 16;
	}
}

?>
