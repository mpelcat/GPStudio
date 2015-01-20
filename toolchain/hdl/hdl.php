<?php

require_once("toolchain.php");

require("vhdl_generator.php");
require("top_level.php");

require_once("fi.php");
require_once("bi.php");

class HDL_toolchain extends Toolchain
{

	public function configure_project($node)
	{
		foreach($node->blocks as $block)
		{
			$block->configure($node, $block);
		}
		
		// add flow interconnect with config
		$flowInterconnect = new FlowInterconnect();
		array_push($node->blocks, $flowInterconnect);
		$flowInterconnect->configure($node, $flowInterconnect);
		
		// add bus interconnect
		$busInterconnect = new BusInterconnect();
		array_push($node->blocks, $busInterconnect);
		$busInterconnect->configure($node, $busInterconnect);
	}
	
	public function generate_project($node, $path)
	{
		foreach($node->blocks as $block)
		{
			$block->generate($node, $block, $path, 'hdl');
		}
		generate_top_level($node, $path);
	}
}

?>
