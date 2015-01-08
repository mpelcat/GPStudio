<?php

class Clock
{
	public $name;
	public $group;
	public $min;
	public $max;
	public $typical;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->group	= (string)$xml['group'];
		$this->min		= (int)$xml['min'];
		$this->max		= (int)$xml['max'];
		$this->typical	= (string)$xml['typical'];
	}
}

?>
