<?php

class FlowConnect
{
	public $fromblock;
	public $fromflow;
	public $toblock;
	public $toflow;
	
	function __construct($xml=null)
	{
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->fromblock = (string)$xml['fromblock'];
		$this->fromflow = (string)$xml['fromflow'];
		$this->toblock = (string)$xml['toblock'];
		$this->toflow = (string)$xml['toflow'];
	}
}

?>
