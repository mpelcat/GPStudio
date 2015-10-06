<?php

define("LIB_PATH", realpath(dirname(__FILE__).DIRECTORY_SEPARATOR.'..').DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
define("DISTRIB_PATH", realpath(dirname(__FILE__)).DIRECTORY_SEPARATOR);
define("WIN_DISTRIB_PATH", DISTRIB_PATH.DIRECTORY_SEPARATOR."gpstudio_win".DIRECTORY_SEPARATOR);
define("LINUX_DISTRIB_PATH", DISTRIB_PATH.DIRECTORY_SEPARATOR."gpstudio_linux".DIRECTORY_SEPARATOR);

include("distrib_utils.php");

include("distrib_scripts.php");

distrib_scripts();

?>
