<?php

require_once("block.php");
require_once("flow_connect.php");

class FlowInterconnect extends Block
{
	public $connects;
	public $tree_connects;

	function __construct($node_config)
	{
		parent::__construct();
		$this->connects = array();
		$this->name="fi";
		
		$this->parse_config_xml($node_config);
	}
	
	protected function parse_config_xml($node_config)
	{
		// flow connections
		if(isset($node_config->connects))
		{
			foreach($node_config->connects->connect as $connect)
			{
				array_push($this->connects, new FlowConnect($connect));
			}
		}
	}
	
	function configure($node)
	{
		$reset = new Reset();
		$reset->name='reset';
		$reset->direction='in';
		$reset->group='reset_n';
		array_push($this->resets, $reset);
		
		foreach($node->blocks as $block)
		{
			foreach($block->flows as $flow)
			{
				if($flow->type=='in' or $flow->type=='out')
				{
					$flow_interface = new Flow();
					$flow_interface->name = $block->name . '_' . $flow->name;
					$flow_interface->type = $flow->type.'_conn';
					$flow_interface->size = $flow->size;

					array_push($this->flows, $flow_interface);
					//array_push($this->params, new Param());
				}
			}
			
			// compute connexion
			$tree_connects = array();
			foreach($this->connects as $connect)
			{
				// check connexion
				if(!$fromblock=$node->getBlock($connect->fromblock)) { echo "Block '$connect->fromblock' doesn't exists.\n"; exit; }
				if(!$fromflow=$fromblock->getFlow($connect->fromflow)) { echo "Flow '$connect->fromflow' doesn't exists in block '$connect->fromblock'.\n"; exit; }
				if(!$toblock=$node->getBlock($connect->toblock)) { echo "Block '$connect->toblock' doesn't exists.\n"; exit; }
				if(!$toflow=$toblock->getFlow($connect->toflow)) { echo "Flow '$connect->toflow' doesn't exists in block '$connect->toblock'.\n"; exit; }
				
				// create tree of connexions
				if(!array_key_exists($toblock->name.'_'.$toflow->name, $tree_connects))
				{
					$tree_connects[$toblock->name.'_'.$toflow->name] = array();
					$tree_connects[$toblock->name.'_'.$toflow->name]['size'] = $toflow->size;
				}
				array_push($tree_connects[$toblock->name.'_'.$toflow->name], array('name' => $fromblock->name.'_'.$fromflow->name, 'size' => $fromflow->size));
			}
		}
		
		echo "\n" . '// =============== Flow connections ===============' . "\n";
		print_r($tree_connects);
		$this->tree_connects = $tree_connects;
		
		// create params for each mux
		$count_param=0;
		foreach($this->tree_connects as $in_connect => $out_connects)
		{
			$param = new Param();
			$param->name = $in_connect;
			$param->regaddr = $count_param;
			$param->default = 0;
			$param->hard = false;
			
			foreach($out_connects as $key => $out_connect)
			{
				if(is_numeric($key))
				{
					$param->enum[$key] = $out_connect['name'];
				}
			}
			
			array_push($this->params, $param);
			$count_param++;
		}
		
		if($count_param==1) $this->size_addr_rel=1;
		else $this->size_addr_rel = ceil(log($count_param, 2));
	}
}

?>
