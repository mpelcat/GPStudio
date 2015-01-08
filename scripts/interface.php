<?php

class InterfaceBus
{
	public $name;
	public $blockname;
	public $type;
	public $size_addr;
	
	function __construct($name, $blockname, $type, $size_addr)
	{
		$this->name=$name;
		$this->blockname=$blockname;
		$this->type=$type;
		$this->size_addr=$size_addr;
	}
}

?>
