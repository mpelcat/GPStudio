<?php

require_once("ci.php");

class PLL
{
	public $inFreqs;
	public $outFreqs;
	public $vco;
	public $mul;
	
	public $clkByPLL;
	public $vcomin;
	public $vcomax;
	public $mulmax;
	public $divmax;
	
	public $dummyClc;
	
	function __construct()
	{
		$this->inFreqs = array();
		$this->outFreqs = array();
		$this->clksshift = array();
		
		$this->clocks = array();
		
		$this->dummyClc = 0;
	}
	
	function freqIn()
	{
		$inFreq = array_values($this->inFreqs);
		$inFreq = $inFreq[0];
		$this->mul = ceil($this->vco / $inFreq);
		return $inFreq;
	}
	
	function isempty()
	{
		return empty($this->outFreqs);
	}
	
	function canBeAdded($clock)
	{
		if(count($this->outFreqs)+$this->dummyClc>=$this->clkByPLL) return false;
		
		$find=false;
		foreach($this->inFreqs as $inFreq)
		{
			$vco = ClockInterconnect::ppcm_array(array_merge($this->outFreqs, array($clock->typical, $inFreq)));
			if($vco<$this->vcomin)
			{
				$vco = ceil(($this->vcomin/2) / $vco) * $vco;
			}
			//if($vco>$this->vcomax) return false;
			//echo $clock->typical;
			//var_dump($vco);
			if($vco<=$this->vcomax) $find=true;
		}
		if($find==false) return false;
		//echo "vco=$vco, freq=$clock->typical\n";
		
		$div=ceil($vco / $clock->typical);
		if($div>$this->divmax*$this->divmax) return false;
		if($div>$this->divmax)
		{
			if(count($this->outFreqs)+$this->dummyClc+1>=$this->clkByPLL) return false;
		}
		
		$can = false;
		foreach($this->inFreqs as $inFreq)
		{
			$mul = ceil($vco / $inFreq);
			//echo "mul=$mul, inFreq=$inFreq, freq=$clock->typical\n";
			if($mul<$this->mulmax) $can=true;
		}
		
		return $can;
	}
	
	function addFreq($clock)
	{
		if(count($this->outFreqs)+$this->dummyClc>=$this->clkByPLL) return;
		
		$vco = ClockInterconnect::ppcm_array(array_merge($this->outFreqs, array($clock->typical)));
		if($vco<$this->vcomin)
		{
			$vco = ceil($this->vcomin / $vco) * $vco;
		}
		if($vco>$this->vcomax) return;
		
		foreach($this->inFreqs as $inFreq)
		{
			$vco = ClockInterconnect::ppcm_array(array_merge($this->outFreqs, array($clock->typical, $inFreq)));
			if($vco<$this->vcomin)
			{
				$vco = ceil($this->vcomin / $vco) * $vco;
			}
			if($vco>$this->vcomax)
			{
				if(($key = array_search($inFreq, $this->inFreqs)) !== false) unset($this->inFreqs[$key]);
			}
			
			$mul = ceil($vco / $inFreq);
			if($mul>$this->mulmax)
			{
				if(($key = array_search($inFreq, $this->inFreqs)) !== false) unset($this->inFreqs[$key]);
			}
		}
		
		$this->vco=$vco;
		
		array_push($this->outFreqs, $clock->typical);
		array_push($this->clksshift, array($clock->typical, $clock->shift));
		array_push($this->clocks, $clock);
		
		$div=ceil($vco / $clock->typical);
		if($div>$this->divmax)
		{
			$this->dummyClc++;
		}
	}
}

?>
