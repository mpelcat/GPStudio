<?php
$version_cache = '';
$license_cache = '';

function getVersion()
{
    global $version_cache;
    if (empty($version_cache))
    {
        $filename = LIB_PATH . DIRECTORY_SEPARATOR . 'version.txt';
        $handle = fopen($filename, 'r');
        $version_cache = fread($handle, filesize($filename));

        $version_cache = str_replace("\n", "", $version_cache);
        $version_cache = str_replace("\r", "", $version_cache);

        exec("cat " . LIB_PATH . ".git/ORIG_HEAD", $out);

        $version_cache.=" based on repo " . $out[0];

        fclose($handle);
    }
    return $version_cache;
}

function getLicense()
{
    global $license_cache;
    if (empty($license_cache))
    {
        $filename = DISTRIB_PATH . DIRECTORY_SEPARATOR . 'license';
        $handle = fopen($filename, 'r');
        $license_cache = fread($handle, filesize($filename));
        $license_cache = str_replace('%%version%%', getVersion(), $license_cache);
        $license_cache = str_replace('%%date%%', date('Y-m-d H:i'), $license_cache);
        fclose($handle);
    }
    return $license_cache;
}

function getComments($text, $type)
{
    if ($type == "c")
    {
        return "/**" . "\n" . $text . "**/" . "\n" . "\n";
    }
    elseif ($type == "vhdl")
    {
        return '-- ' . str_replace("\n", "\n-- ", $text) . "\n" . "\n";
    }
    elseif ($type == "php")
    {
        return "<?php" . "\n" . "/**" . "\n" . $text . "**/" . "\n" . "?>" . "\n";
    }
    else
        return $text;
}

function mkdirExists($dir)
{
    if (!file_exists($dir))
        mkdir($dir);
}
