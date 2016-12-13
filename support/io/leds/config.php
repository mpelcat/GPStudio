<?php

return function($node, $block)
{
    $ledcount = $block->getParam("LEDCOUNT")->value;

    $led_register = $block->getParam("ENABLE");
    
    $part = $block->getPart("main");

    for($i=0; $i<$ledcount; $i++)
    {
        $property = new Property();
        $property->name = "led".$i."_enable";
        $property->caption = "led".$i." enable";
        $property->type = 'bool';
        $block->addProperty($property);

        $partProperty = new ComponentPartProperty();
        $partProperty->name = "led".$i."_enable";
        $partProperty->x_pos = 10;
        $partProperty->y_pos = $i*(110/($ledcount+1))+10;
        $partProperty->width = 80;
        $partProperty->height = 15;
        $part->addPartProperty($partProperty);

        if($i==0)
            $led_register->propertymap = $property->name . ".value";
        else
            $led_register->propertymap .= " + ".$property->name . ".value" . " * " . pow(2, $i);
    }

    $block->toGlobalPropertyPath($block->name);
}

?>
