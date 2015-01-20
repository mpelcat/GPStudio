<?php

class Toolchain
{
	
	function __construct()
	{
		
	}
	
	public function configure_project($node)
	{
	}
	
	public function generate_project($node, $path)
	{
	}
	
	static public function load($toolchain_name)
	{
		switch ($toolchain_name)
		{
			case 'hdl':
				require("toolchain/hdl/hdl.php");
				return new HDL_toolchain();
				break;
			case 'altera_quartus':
				require("toolchain/altera_quartus/altera_quartus.php");
				return new Altera_quartus_toolchain();
				break;
			default:
				throw new Exception ('Toolchain \''.$toolchain_name.'\' doesn\'t exists.');
      }
	}
}

?>
