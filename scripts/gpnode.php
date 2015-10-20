<?php

define("LIB_PATH", realpath(dirname(__FILE__)."/..").DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'model');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'system_interconnect');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'support');

require_once("node.php");
require_once("gpstudio.php");

$options = getopt("a:");
if(array_key_exists('a',$options)) $action = $options['a']; else error("You should specify an action with -a"."\n",1);

// new project creation
if($action=="newproject")
{
	$options = getopt("a:n:");
	if(array_key_exists('n',$options)) $project=$options['n']; else error("You should specify a project name with -n"."\n",1);
	
	$node = new Node();
	$node->name=$project;
	$project.=".node";
}
else
{
	$project=findproject();
	if(!file_exists($project)) error("Cannot find a valid project in the current directory.",1);
	
	$node = new Node($project);
}

// process action, pre config
switch($action)
{
	// =========================== project commands =========================== 
	case "newproject":
		// nothing to do
		break;
	case "setboard":
		$options = getopt("a:n:");
		if(array_key_exists('n',$options)) $boardName = $options['n']; else error("You should specify a board name with -n"."\n",1);
		$node->setBoard($boardName);
		break;
		
	case "generate":
		$options = getopt("a:o::");
		if(array_key_exists('o',$options)) $outDir = $options['o']; else $outDir=getcwd();
		break;
		
	// =========================== io commands =========================== 
	case "addio":
		$options = getopt("a:n:");
		if(array_key_exists('n',$options)) $ioName = $options['n']; else error("You should specify an io name with -n"."\n",1);
		
		if(!isset($node->board)) error("You should specify a board with gpnode setboard before add io."."\n",1);
		if($node->getBlock($ioName)!=NULL) error("This io name is ever added."."\n",1);
		
		$node->addIo($ioName);
		break;
		
	case "delio":
		$options = getopt("a:n:");
		if(array_key_exists('n',$options)) $ioName = $options['n']; else error("You should specify an io name with -n"."\n",1);
		
		if(!isset($node->board)) error("You should specify a board with gpnode setboard before del io."."\n",1);
		if($node->getBlock($ioName)==NULL) error("This io name doesn't exists."."\n",1);
		
		$node->delIo($ioName);
		break;
		
	case "showio":
		$options = getopt("a:f::");
		if(array_key_exists('f',$options)) $format = $options['f']; else $format="";
		
		echo "ios :" . "\n";
		foreach($node->blocks as $block)
		{
			if($block->type()=="io")
			{
				echo "  + ".$block->name . "\n";
			}
		}
		break;
		
	// =========================== process commands =========================== 
	case "addprocess":
		$options = getopt("a:d:n:");
		if(array_key_exists('d',$options)) $processDriver = $options['d']; else error("You should specify a process driver with -d"."\n",1);
		if(array_key_exists('n',$options)) $processName = $options['n']; else $processName = $processDriver;
		
		if($node->getBlock($processName)!=NULL) error("This process name is ever added."."\n",1);
		
		$node->addProcess($processName, $processDriver);
		break;
		
	case "delprocess":
		$options = getopt("a:n:");
		if(array_key_exists('n',$options)) $processName = $options['n']; else error("You should specify an process name with -n"."\n",1);
		
		if($node->getBlock($processName)==NULL) error("This process name doesn't exists."."\n",1);
		
		$node->delProcess($processName);
		break;
		
	case "showprocess":
		$options = getopt("a:f::");
		if(array_key_exists('f',$options)) $format = $options['f']; else $format="";
		
		echo "process :" . "\n";
		foreach($node->blocks as $block)
		{
			if($block->type()=="process")
			{
				echo "  + ".$block->name . "\n";
			}
		}
		break;
		
	// =========================== flow connections commands =========================== 
	case "connect":
	case "unconnect":
		$options = getopt("a:f:t:");
		if(array_key_exists('f',$options)) $from = $options['f'];	else error("You should specify a source flow with -f"."\n",1);
		if(array_key_exists('t',$options)) $to = $options['t'];		else error("You should specify a sink flow with -t"."\n",1);
		
		$fromRes = explode(".", $from, 2);
		if(count($fromRes)!=2) error("Malformed expression from flow -f."."\n",1);
		$fromBlock = $node->getBlock($fromRes[0]);
		if($fromBlock==NULL) error("Block ".$fromRes[0]." doesn't exists."."\n",1);
		$fromFlow = $fromBlock->getFlow($fromRes[1]);
		if($fromFlow==NULL) error("Flow ".$fromRes[1]." in ".$fromRes[0]."doesn't exists."."\n",1);
		
		$toRes = explode(".", $to, 2);
		if(count($toRes)!=2) error("Malformed expression to flow -t."."\n",1);
		$toBlock = $node->getBlock($toRes[0]);
		if($toBlock==NULL) error("Block ".$toRes[0]." doesn't exists."."\n",1);
		$toFlow = $toBlock->getFlow($toRes[1]);
		if($toFlow==NULL) error("Flow ".$toRes[1]." in ".$toRes[0]."doesn't exists."."\n",1);
		break;
		
	// =========================== clock domain commands =========================== 
	case "setclockdomain":
		$options = getopt("a:n:v:");
		if(array_key_exists('n',$options)) $clockName = $options['n'];	else error("You should specify the name of the clock domain with -n"."\n",1);
		if(array_key_exists('v',$options)) $value = Clock::convert($options['v']);	else error("You should specify the frequency of the clock domain with -v"."\n",1);
		break;
		
	case "showclockdomain":
		// nothing to do
		break;
		
	// =========================== block attributes commands =========================== 
	case "renameblock":
		$options = getopt("a:n:v:");
		if(array_key_exists('n',$options)) $blockName = $options['n'];	else error("You should specify the name of the block to rename with -n"."\n",1);
		if(array_key_exists('v',$options)) $newName = $options['v'];	else error("You should specify the new name of the block to rename with -v"."\n",1);
		
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process name doesn't exists."."\n",1);
		$block->name = $newName;
		break;
		
	case "setproperty":
		$options = getopt("a:p:n:v:");
		if(array_key_exists('p',$options)) $blockName = $options['p'];	else error("You should specify the name of the block -p"."\n",1);
		if(array_key_exists('n',$options)) $propertyName = $options['n'];	else error("You should specify the name of the property with -n"."\n",1);
		if(array_key_exists('v',$options)) $value = $options['v'];	else error("You should specify the value of the property with -v"."\n",1);
		
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process name doesn't exists."."\n",1);
		$property = $block->getProperty($propertyName);
		if($property==NULL) error("This property name doesn't exists in $blockName."."\n",1);
		$property->value = $value;
		break;
		
	case "setparam":
		$options = getopt("a:p:n:v:");
		if(array_key_exists('p',$options)) $blockName = $options['p'];	else error("You should specify the name of the block -p"."\n",1);
		if(array_key_exists('n',$options)) $paramName = $options['n'];	else error("You should specify the name of the param with -n"."\n",1);
		if(array_key_exists('v',$options)) $value = $options['v'];	else error("You should specify the value of the param with -v"."\n",1);
		
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process name doesn't exists."."\n",1);
		$param = $block->getParam($paramName);
		if($param==NULL) error("This param name doesn't exists in $blockName."."\n",1);
		$property->value = $value;
		break;
		
	case "setclock":
		$options = getopt("a:p:n:v:");
		if(array_key_exists('p',$options)) $blockName = $options['p'];	else error("You should specify the name of the block -p"."\n",1);
		if(array_key_exists('n',$options)) $clockName = $options['n'];	else error("You should specify the name of the clock with -n"."\n",1);
		if(array_key_exists('v',$options)) $value = Clock::convert($options['v']);	else error("You should specify the frequency of the clock with -v"."\n",1);
		
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process name doesn't exists."."\n",1);
		$clock = $block->getClock($clockName);
		if($clock==NULL) error("This clock name doesn't exists in $blockName."."\n",1);
		$clock->typical = $value;
		break;
		
	case "setflowsize":
		$options = getopt("a:p:n:v:");
		if(array_key_exists('p',$options)) $blockName = $options['p'];	else error("You should specify the name of the block -p"."\n",1);
		if(array_key_exists('n',$options)) $flowName = $options['n'];	else error("You should specify the name of the flow with -n"."\n",1);
		if(array_key_exists('v',$options)) $flowsize = $options['v'];	else error("You should specify the size of the flow with -v"."\n",1);
		
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process name doesn't exists."."\n",1);
		$flow = $block->getFlow($flowName);
		if($flow==NULL) error("This flow name doesn't exists in $blockName."."\n",1);
		$flow->size = $flowsize;
		break;
	
	default:
		error("Action $action is unknow.",1);
}

// create toolchain depend of the config node
if(isset($node->board))
{
	$toolchain = $node->board->toolchain;
	$toolchain->configure_project($node);
}

// process action, post config
switch($action)
{
	case "generate":
		if(!isset($toolchain))
		{
			error("You should specify a board with gpnode setboard before generate."."\n",1);
		}
		$toolchain->generate_project($node, $outDir);
		$node->saveXml($outDir.DIRECTORY_SEPARATOR."node_generated.xml");
		message("Project successfully generated ($warningCount warnings).");
		break;
	case "connect":
		$node->getBlock("fi")->addFlowConnect(new FlowConnect($fromBlock->name, $fromFlow->name, $toBlock->name, $toFlow->name));
		break;
	case "unconnect":
		$node->getBlock("fi")->delFlowConnect($fromBlock->name, $fromFlow->name, $toBlock->name, $toFlow->name);
		break;
	case "showconnects":
		echo "connects :" . "\n";
		foreach($node->getBlock("fi")->flow_connects as $flow_connect)
		{
			echo "  + ".$flow_connect->fromblock.".".$flow_connect->fromflow." -> ".$flow_connect->toblock.".".$flow_connect->toflow." (".$flow_connect->order.")"."\n";
		}
		break;
	case "setclockdomain":
		$node->getBlock("ci")->addClockDomain(new ClockDomain($clockName, $value));
		break;
	case "showclockdomain":
		echo "domains :" . "\n";
		foreach($node->getBlock("ci")->domains as $domain)
		{
			echo "  + ".$domain->name." = ".Clock::formatFreq($domain->typical)."\n";
		}
		break;
}

$node->saveProject($project);

?>
