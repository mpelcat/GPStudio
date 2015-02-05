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
		$this->desc		= (string)$xml['desc'];
		
		if((string)$xml['hard']=="1" or (string)$xml['hard']=="true") $this->hard=true; else $this->hard=false;
		
		// ports
		if(isset($xml->enums))
		{
			/*foreach($this->xml->ports->port as $port)
			{
				array_push($this->ext_ports, new Port($port));
			}*/
		}
	}
}

?>
