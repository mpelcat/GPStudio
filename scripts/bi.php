<?php

require_once("block.php");

class BusInterconnect extends Block
{
	public $addr_bus_width;

	function __construct()
	{
		parent::__construct();
		$this->name="bi";
	}
	
	function configure($node)
	{
		$reset = new Reset();
		$reset->name='reset';
		$reset->direction='in';
		$reset->group='reset_n';
		array_push($this->resets, $reset);
		
		// compute the size of the memory bus
		$sum_space_addr_rel = 0;
		foreach($node->blocks as $block)
		{
			if($block->size_addr_rel>0)
			{
				$size_addr_space = pow(2, $block->size_addr_rel);
				$sum_space_addr_rel += $size_addr_space;
			}
		}
		$this->addr_bus_width = ceil(log($sum_space_addr_rel,2));
		
		// compute the adress relative of each block
		$max_addr = pow(2, $this->addr_bus_width) - 1;
		$addr_space = array_fill(0, $max_addr, -1);
		foreach($node->blocks as $block)
		{
			if($block->size_addr_rel>0)
			{
				$size_addr_space = pow(2, $block->size_addr_rel);
				for($addr=0; $addr<$max_addr; $addr+=$size_addr_space)
				{
					if($addr_space[$addr]==-1)
					{
						$block->addr_abs = $addr;
						array_push($block->interfaces, new InterfaceBus("bus_sl",$block->name,"bi_slave",$block->size_addr_rel));
						array_push($this->interfaces, new InterfaceBus("bus_sl_$block->name",$block->name,"bi_slave_conn",$block->size_addr_rel));
						for($i=0; $i<$size_addr_space; $i++) $addr_space[$addr+$i]=0;
						break;
					}
				}
			}
			if($block->master_count>0)
			{
				for($i=0; $i<$block->master_count; $i++)
				{
					array_push($block->interfaces, new InterfaceBus("bus_master",$block->name,"bi_master",$this->addr_bus_width));
					array_push($this->interfaces, new InterfaceBus("bus_master_$block->name",$block->name,"bi_master_conn",$this->addr_bus_width));
					
					$param = new Param();
					$param->name = 'MASTER_ADDR_WIDTH';
					$param->value = $this->addr_bus_width;
					$param->hard = true;
					array_push($block->params, $param);
				}
			}
		}
		
		echo "\n" . '// =============== Slaves addr ===============' . "\n";
		foreach($node->blocks as $block)
		{
			if($block->size_addr_rel>0)
			{
				echo $block->name . ' : ' . $block->addr_abs . "\n";
			}
		}
	}
}

?>
