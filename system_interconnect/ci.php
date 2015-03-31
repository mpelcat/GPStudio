<?php

require_once("block.php");

require_once("toolchain/hdl/vhdl_generator.php");

class ClockInterconnect extends Block
{
	public $connects;
	public $tree_connects;

	function __construct()
	{
		parent::__construct();
		$this->name="ci";
		$this->driver="ci";
	}
	
	function configure($node, $block)
	{
		$reset = new Reset();
		$reset->name='reset';
		$reset->direction='in';
		$reset->group='reset_n';
		$this->addReset($reset);
		
		foreach($node->board->clocks as $clock)
		{
			if(!isset($clock->group) or $clock->group=="") $clock->group=$clock->name;
			echo "clock $clock->name($clock->direction, $clock->group) $block->name"."\n";
		}
		foreach($node->blocks as $block)
		{
			foreach($block->clocks as $clock)
			{
				if(!isset($clock->group) or $clock->group=="") $clock->group=$block->name.'_'.$clock->name;
				echo "clock $clock->name($clock->direction, $clock->group) $block->name"."\n";
			}
		}
	}
	
	function generate($node, $block, $path, $language)
	{
		$generator = new VHDL_generator('ci');
	
		if(!$ci=$node->getBlock('ci')) return;
		$generator->fromBlock($ci);
	
		$code='';
	
		$generator->code=$code;
	
		$filename = $path.DIRECTORY_SEPARATOR.'clock_interconnect.vhd';
		$generator->save_as_ifdiff($filename);
	
		$file = new File();
		$file->name = 'clock_interconnect.vhd';
		$file->group = 'hdl';
		$file->type = 'vhdl';
		$ci->addFile($file);
	}
	
	public function type() {return 'ci';}
	
	public function getXmlElement($xml)
	{
		$xml_element = parent::getXmlElement($xml);
		
		return $xml_element;
	}
}

?>
