<?php

require_once("toolchain.php");
require_once("toolchain/hdl/hdl.php");

require("tcl.php");
require("project.php");

class Altera_quartus_toolchain extends HDL_toolchain
{
	public function configure_project($node)
	{
		parent::configure_project($node);
	}
	
	public function generate_project($node, $path)
	{
		parent::generate_project($node, $path);
		generate_tcl($node, $path);
		generate_project_file($node, $path);
	}
}



?>
