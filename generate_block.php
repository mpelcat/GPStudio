<?php

define("LIB_PATH", realpath(dirname(__FILE__)).DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'model');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'system_interconnect');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'support');
set_include_path(get_include_path().PATH_SEPARATOR.SUPPORT_PATH.DIRECTORY_SEPARATOR);

require_once("gpstudio.php");
require_once("node.php");
require_once('toolchain'.DIRECTORY_SEPARATOR.'hdl'.DIRECTORY_SEPARATOR."vhdl_generator.php");

// create node data structure from config file
$config_block_file = $argv[1];
if(!file_exists($config_block_file)) error('The config file does\'nt exist.',1);

$blocks = array();
if(substr($config_block_file, -3)===".io")
{
	$io = new IO($config_block_file);
	$io->name=preg_replace('/\\.[^.\\s]{2,5}$/', '', basename($config_block_file));
	array_push($blocks, $io);
}
elseif(substr($config_block_file, -5)===".proc")
{
	$proc = new Process($config_block_file);
	$proc->name=preg_replace('/\\.[^.\\s]{2,5}$/', '', basename($config_block_file));
	array_push($blocks, $proc);
}
elseif(substr($config_block_file, -5)===".node")
{
	$node = new Node($config_block_file);
	foreach($node->blocks as $block)
	{
		if($block->in_lib==false) array_push($blocks, $block);
	}
}
else error('The config file is not a know extension.',1);

foreach($blocks as $block)
{
	$slave_generator = NULL;
	if($block->pi_size_addr_rel>0)
	{
		array_push($block->interfaces, new InterfaceBus("bus_sl",$block->name,"pi_slave",$block->pi_size_addr_rel));
		
		$slave_generator = new VHDL_generator($block->name . '_slave');
		$slave_block = new Block();
		$slave_block->name = $block->name . '_slave';
		$slave_block->driver = $block->name . '_slave';
		$slave_block->clocks = array();
		$slave_block->interfaces = $block->interfaces;
	}

	$block_generator = new VHDL_generator($block->name);
	$block_generator->fromBlock($block);
	if(empty($block->path)) $path=''; else $path=$block->path.DIRECTORY_SEPARATOR;
	
	$process_generator = new VHDL_generator($block->name . '_process');
	
	$process_block = new Block();
	$process_block->name = $block->name . '_process';
	$process_block->driver = $block->name . '_process';
	$process_block->clocks = array();
	$process_block->flows = $block->flows;
	$process_block->params = $block->params;
	
	// clocks
	foreach($block->clocks as $clock)
	{
		$nclock = new Clock();
		$nclock->name = $clock->name;
		$nclock->net = $clock->name;
		$nclock->typical = strtoupper($clock->name).'_FREQ';
		array_push($process_block->clocks, $nclock);
		array_push($slave_block->clocks, $nclock);
	}
	
	// resets
	foreach($block->resets as $reset)
	{
		$nreset = new Clock();
		$nreset->name = $reset->name;
		$nreset->group = $reset->name;
		array_push($process_block->resets, $nreset);
		if($slave_generator!=NULL) array_push($slave_block->resets, $nreset);
	}
	
	if($slave_generator!=NULL) $slave_generator->fromBlock($slave_block);
	$process_generator->fromBlock($process_block);
	
	// registers
	$slave_generator->addPortComment(str_pad(' registers output ',55,'=',STR_PAD_BOTH));
	$process_generator->addPortComment(str_pad(' registers input ',55,'=',STR_PAD_BOTH));
	if($slave_generator!=NULL)
	{
		foreach($block->params as $param)
		{
			if($param->hard==false)
			{
				if(empty($param->parambitfields))
				{
					echo $param->name."\n";
					$slave_generator->addPort($param->name,32,'out');
					$process_generator->addPort($param->name,32,'in');
				}
				else
				{
					foreach($param->parambitfields as $parambitfields)
					{
						
					}
				}
			}
		}
	}
	
	$block_generator->addblock($process_block);
	if($slave_generator!=NULL) $block_generator->addblock($slave_block);
	
	$block_generator->save_as($path.$block->name   . '.vhd');
	$process_generator->save_as($path.$block->name . '_process.vhd');
	$slave_generator->save_as($path.$block->name   . '_slave.vhd');

	echo $block->name.'.vhd'.' generated'."\n";
}

?>
