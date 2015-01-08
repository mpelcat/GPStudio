<?php

class Pin
{
	public $name;
	public $mapto;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->mapto	= (string)$xml['mapto'];
	}
}

?>
