<?php

class Reset
{
	public $name;
	public $group;
	public $direction;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->group	= (string)$xml['group'];
		$this->direction= (string)$xml['direction'];
	}
}

?>
