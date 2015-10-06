<?php

return function($node, $block, $path, $language)
{
	echo 'generate'.$node->name."\n";
	echo shell_exec('ls');
}
?>
