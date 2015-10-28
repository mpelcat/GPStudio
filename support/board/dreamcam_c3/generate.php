<?php

return function($node, $path, $language)
{
	// generate file configuration for quartus_pgm
	$content  = "/* Quartus II 32-bit Version 13.1.0 Build 162 10/23/2013 SJ Full Version */"."\r\n";
	$content .= "JedecChain;"."\r\n";
	$content .= "	FileRevision(JESD32A);"."\r\n";
	$content .= "	DefaultMfr(6E);"."\r\n";
	$content .= ""."\r\n";
	$content .= "	P ActionCode(Cfg)"."\r\n";
	$content .= "		Device PartName(EP3C120F780) Path(\"output_files/\") File(\"".$node->name.".sof\") MfrSpec(OpMask(1));"."\r\n";
	$content .= ""."\r\n";
	$content .= "ChainEnd;"."\r\n";
	$content .= ""."\r\n";
	$content .= "AlteraBegin;"."\r\n";
	$content .= "	ChainType(JTAG);"."\r\n";
	$content .= "AlteraEnd;"."\r\n";

	$filename = $node->name.".cdf";

	// save file if it's different
	if(!file_exists($path.DIRECTORY_SEPARATOR.$filename))
	{
		$handle = fopen($path.DIRECTORY_SEPARATOR.$filename, 'r');
		$actualContent = fread($handle, filesize($path.DIRECTORY_SEPARATOR.$filename));
		fclose($handle);
		if($actualContent != $content) $needToReplace = true;
	}
	else $needToReplace = true;

	if($needToReplace)
	{
		$handle = null;
		if (!$handle = fopen($path.DIRECTORY_SEPARATOR.$filename, 'w')) error("$filename cannot be openned",5,"Toolchain");
		if (fwrite($handle, $content) === FALSE) error("$filename cannot be written",5,"Vhdl Gen");
		fclose($handle);
	}
}
?>
