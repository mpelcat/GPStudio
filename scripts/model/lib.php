<?php

/* 
 * Copyright (C) 2014 Dream IP
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

class Lib
{
	public $ios;
	public $boards;
	public $process;
	public $toolchain;
	
	function __construct($libpaths)
	{
		$this->ios = array();
		$this->boards = array();
		$this->process = array();
		$this->toolchains = array();
		
		if(!is_array($libpaths)) $libpaths=array($libpaths);
		
		foreach($libpaths as $libpath)
		{
			$this->openlib($libpath);
		}
	}
	
	protected function openlib($libpath)
	{
		// process
		$processDir = $libpath.DIRECTORY_SEPARATOR."process".DIRECTORY_SEPARATOR;
		$dirs = scandir($processDir);
		foreach($dirs as $dir)
		{
			if(is_dir($processDir.$dir) and $dir!='.' and $dir!='..')
			{
				if(file_exists($processDir.$dir.DIRECTORY_SEPARATOR.$dir.".proc")) $this->process[]=$dir;
			}
		}
		
		// ios
		$ioDir = $libpath.DIRECTORY_SEPARATOR."io".DIRECTORY_SEPARATOR;
		$dirs = scandir($ioDir);
		foreach($dirs as $dir)
		{
			if(is_dir($ioDir.$dir) and $dir!='.' and $dir!='..')
			{
				if(file_exists($ioDir.$dir.DIRECTORY_SEPARATOR.$dir.".io")) $this->ios[]=$dir;
			}
		}
		
		// boards
		$boardDir = $libpath.DIRECTORY_SEPARATOR."board".DIRECTORY_SEPARATOR;
		$dirs = scandir($boardDir);
		foreach($dirs as $dir)
		{
			if(is_dir($boardDir.$dir) and $dir!='.' and $dir!='..')
			{
				if(file_exists($boardDir.$dir.DIRECTORY_SEPARATOR.$dir.".dev")) $this->boards[]=$dir;
			}
		}
		
		// toolchains
		$toolchainDir = $libpath.DIRECTORY_SEPARATOR."toolchain".DIRECTORY_SEPARATOR;
		$dirs = scandir($toolchainDir);
		foreach($dirs as $dir)
		{
			if(is_dir($toolchainDir.$dir) and $dir!='.' and $dir!='..')
			{
				if(file_exists($toolchainDir.$dir.DIRECTORY_SEPARATOR.$dir.".php")) $this->toolchains[]=$dir;
			}
		}
	}
	
	public function type() {return 'process';}
	
	public function getXmlElement($xml, $format)
	{
		$xml_element = parent::getXmlElement($xml, $format);
		
		return $xml_element;
	}
}

?>
