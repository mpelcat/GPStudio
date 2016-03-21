<?php

/* 
 * Copyright (C) 2016 Dream IP
 * 
 * This file is part of GPStudio.
 *
 * GPStudio is a free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
