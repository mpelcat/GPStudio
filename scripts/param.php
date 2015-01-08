<?php

class Param
{
	public $name;
	public $type;
	public $enum;
	public $regaddr;
	public $value;
	public $default;
	public $min;
	public $max;
	public $hard;
	public $desc;
	
	function __construct($xml=null)
	{
		$this->enum	= array();
		if($xml) $this->parse_xml($xml);
	}
	
	protected function parse_xml($xml)
	{
		$this->name		= (string)$xml['name'];
		$this->type		= (string)$xml['type'];
		$this->regaddr	= (string)$xml['regaddr'];
		$this->value	= (string)$xml['value'];
		$this->default	= (string)$xml['default'];
		$this->min		= (string)$xml['min'];
		$this->max		= (string)$xml['max'];
		$this->hard		= (string)$xml['hard'];
		$this->desc		= (string)$xml['desc'];
	}
}

?>
