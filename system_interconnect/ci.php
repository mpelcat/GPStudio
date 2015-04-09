<?php

require_once("block.php");

require_once("toolchain/hdl/vhdl_generator.php");

function formatFreq($freq)
{
    if($freq>1000000)
    {
		return (floor($freq/1000)/1000).' MHz';
	}
	elseif($freq>1000)
	{
		return ($freq/1000).' kHz';
	}
	else
	{
		return $freq.' Hz';
	}
}

class ClockInterconnect extends Block
{
	public $clock_providers;
	public $clock_receivers;
	public $available_freq;
	public $needed_freq;
	
	function __construct()
	{
		parent::__construct();
		$this->clock_providers = array();
		$this->clock_receivers = array();
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
		
		$this->clock_providers = array();
		$this->clock_receivers = array();
		
		$this->available_freq = array();
		$this->needed_freq = array();
		
		// construct list of clock providers and clock receivers
		foreach($node->board->clocks as $clock)
		{
			if($clock->direction=="out") array_push($this->clock_providers, $clock); else array_push($this->clock_receivers, $clock); 
		}
		foreach($node->blocks as $block)
		{
			foreach($block->clocks as $clock)
			{
				if($clock->direction=="out") array_push($this->clock_providers, $clock); else array_push($this->clock_receivers, $clock); 
			}
		}
		
		// construct list of available clocks
		foreach($this->clock_providers as $clock_provider)
		{
			array_push($this->available_freq, $clock_provider->typical);
			
			$clock = new Clock();
			$clock->name = $clock_provider->name;
			$clock->domain = $clock_provider->domain;
			$clock->typical = $clock_provider->typical;
			$clock->shift = $clock_provider->shift;
			
			if($clock->shift==0)
			{
				$clock->net = 'clk_'.$clock->typical;
				$clock_provider->net = 'clk_'.$clock->typical;
			}
			else
			{
				$clock->net = 'clk_'.$typical.'_'.$clock->shift;
				$clock_provider->net = 'clk_'.$typical.'_'.$clock->shift;
			}
			
			$clock->direction = "in";
			$this->addClock($clock);
			
			//echo $clock_provider->typical . "\n";
		}
		
		// construct list of needed clocks
		foreach($this->clock_receivers as $clock)
		{
			if(isset($clock->typical))
			{
				if(!in_array(array($clock->typical, $clock->shift), $this->needed_freq))
				{
					array_push($this->needed_freq, array($clock->typical, $clock->shift));
					array_push($this->available_freq, array($clock->typical, $clock->shift));
				}
			}
			else
			{
				//echo 'notset'.$clock->name."\n";
				$clock->net = 'clk_proc';
			}
		}
		
		// add clock provider foreach needed clocks
		foreach($this->needed_freq as $clockNeed)
		{
			$clockFreq = $clockNeed[0];
			$clockShift = $clockNeed[1];
			
			$clock = new Clock();
			$clock->typical = $clockFreq;
			$clock->shift = $clockShift;
			if($clock->shift==0) $clock->net = 'clk_'.$clockFreq;
			else $clock->net = 'clk_'.$clockFreq.'_'.$clock->shift;
			$clock->name = $clock->net;
			$clock->domain = "clk_$clockFreq";
			$clock->direction = "out";
			$this->addClock($clock);
			array_push($this->clock_providers, $clock);
		}
		
		// associate clock net
		foreach($this->clock_receivers as $clockin)
		{
			if(empty($clockin->net))
			{
				foreach($this->clock_providers as $clocksrc)
				{
					if($clocksrc->typical==$clockin->typical)
					{
						$clockin->net = $clocksrc->net;
					}
				}
			}
		}
		
		//print_r($this->needed_freq);
	}
	
	function generate($node, $block, $path, $language)
	{
		$generator = new VHDL_generator('ci');
	
		if(!$ci=$node->getBlock('ci')) return;
		$generator->fromBlock($ci);
		
		array_push($generator->libs, "library altera_mf;");
		array_push($generator->libs, "use altera_mf.all;");
		
		$generator->addSignal('pll1_in', 2, 'std_logic_vector');
		$generator->addSignal('pll1_out', 5, 'std_logic_vector');
	
		$declare='';
		$params['clks']=2;
		$declare.=$node->board->toolchain->getRessourceDeclare('pll',$params);
		$generator->declare=$declare;
		
		$code='';
		$params['pllname']='pll1';
		$params['clkin']=$this->clock_providers[0]->typical;
		$params['clks']=$this->needed_freq;
		$code.=$node->board->toolchain->getRessourceInstance('pll',$params);
		
		$clkId=0;
		foreach($this->needed_freq as $clockNeed)
		{
			$clockFreq = $clockNeed[0];
			$clockShift = $clockNeed[1];
			if($clockShift==0) $net = 'clk_'.$clockFreq;
			else $net = 'clk_'.$clockFreq.'_'.$clockShift;
			
			$code.='	'.$net.' <= pll1_out('.$clkId.');'."\n";
			$clkId++;
		}
		$code.='	pll1_in(0) <= '.$this->clock_providers[0]->name.';'."\n";
		
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
		
		// clock_providers
		$xml_clocks = $xml->createElement("clock_providers");
		foreach($this->clock_providers as $clock)
		{
			$clock_element = $clock->getXmlElement($xml);
			
			// name
			$att = $xml->createAttribute('blockName');
			$att->value = $clock->parentBlock->name;
			$clock_element->appendChild($att);
		
			$xml_clocks->appendChild($clock_element);
		}
		$xml_element->appendChild($xml_clocks);
		
		// clock_receivers
		$xml_clocks = $xml->createElement("clock_receivers");
		foreach($this->clock_receivers as $clock)
		{
			$xml_clocks->appendChild($clock->getXmlElement($xml));
		}
		$xml_element->appendChild($xml_clocks);
		
		return $xml_element;
	}
}

?>
