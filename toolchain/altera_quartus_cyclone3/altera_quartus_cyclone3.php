<?php

require("tcl.php");
require("project.php");
require("fi_gen.php");
require("bi_gen.php");
require("top_level.php");

function generate($node, $path)
{
	generate_flow_interconnect($node, $path);
	generate_bus_interconnect($node, $path);
	generate_top_level($node, $path);
	generate_tcl($node, $path);
	generate_project_file($node, $path);
}

?>
