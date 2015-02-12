<?php

class InterfaceBus
{
	/**
	* Name of the interface
	* @var string $name
	*/
	public $name;

	/**
	* Name of the block
	* @var string $blockname
	*/
	public $blockname;

	/**
	* bi_master bi_slave bi_master_conn bi_slave_conn
	* @var string $type
	*/
	public $type;

	/**
	* Sife of the adress bus interface
	* @var int $size_addr
	*/
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
