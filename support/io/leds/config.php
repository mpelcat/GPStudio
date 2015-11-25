<?php

return function($node, $block)
{
	$ledcount = $block->getParam("LEDCOUNT")->value;
	
	$led_register = $block->getParam("ENABLE");
	
	for($i=0; $i<$ledcount; $i++)
	{
		$property = new Property();
		$property->name = "led".$i."_enable";
		$property->caption = "led".$i." enable";
		$property->type = 'bool';
		$block->addProperty($property);
		
		if($i==0) $led_register->propertymap = $property->name . ".value";
		else $led_register->propertymap .= " + ".$property->name . ".value" . " * " . pow(2, $i);
	}
}

?>
