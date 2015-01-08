<?php

class File
{
	public $name;
	public $type;
	public $group;
	public $path;
	public $desc;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name = (string)$xml['name'];
		$this->type = (string)$xml['type'];
		$this->group = (string)$xml['group'];
		$this->path = (string)$xml['path'];
		$this->desc = (string)$xml['desc'];
	}
}

?>
