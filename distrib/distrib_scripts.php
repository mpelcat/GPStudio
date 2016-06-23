<?php

function distrib_scripts($mainoutpath, $system, $archi, $qtver)
{
    echo "copying scripts files in $mainoutpath for $system-$archi-qt$qtver..." . "\n";

    // create directory
    mkdirExists($mainoutpath . "scripts");
    mkdirExists($mainoutpath . "scripts" . DIRECTORY_SEPARATOR . "model");
    mkdirExists($mainoutpath . "scripts" . DIRECTORY_SEPARATOR . "tools");
    mkdirExists($mainoutpath . "scripts" . DIRECTORY_SEPARATOR . "system_interconnect");

    // copy scripts
    $paths = array('scripts' . DIRECTORY_SEPARATOR,
        'scripts' . DIRECTORY_SEPARATOR . 'model' . DIRECTORY_SEPARATOR,
        'scripts' . DIRECTORY_SEPARATOR . 'tools' . DIRECTORY_SEPARATOR,
        'scripts' . DIRECTORY_SEPARATOR . 'system_interconnect' . DIRECTORY_SEPARATOR);
    foreach ($paths as $path)
    {
        $files = scandir(LIB_PATH . $path);
        foreach ($files as $file)
        {
            if (substr($file, -4) === ".php")
            {
                $filename = LIB_PATH . $path . $file;

                $handle_read = fopen($filename, 'r');
                $content_file = fread($handle_read, filesize($filename));
                fclose($handle_read);

                $filename = $mainoutpath . $path . $file;
                $handle_write = fopen($filename, 'w');
                fwrite($handle_write, $content_file);
                fclose($handle_write);
            }
        }
    }
    echo "done." . "\n";
}

function distrib_support($mainoutpath, $system, $archi, $qtver)
{
    echo "copying support files in $mainoutpath for $system-$archi-qt$qtver..." . "\n";

    // create directory
    mkdirExists($mainoutpath . "support");

    foreach (array("board", "io", "process", "toolchain", "component") as $dir)
    {
        $path = $mainoutpath . "support" . DIRECTORY_SEPARATOR . $dir . DIRECTORY_SEPARATOR;
        mkdirExists($path);

        $filename = DISTRIB_PATH . $dir . ".txt";
        $handle_read = fopen($filename, 'r');

        if ($handle_read)
        {
            while (($line = fgets($handle_read)) !== false)
            {
                $line = str_replace("\n", "", $line);
                $line = str_replace("\r", "", $line);

                $ip = $line;
                echo "	+ " . $dir . " " . $ip . "\n";

                mkdirExists($path . $ip);
                cpy_dir(SUPPORT_PATH . $dir . DIRECTORY_SEPARATOR . $ip, $path . $ip);
            }
            fclose($handle_read);
        }
    }
    echo "done." . "\n";
}

function distrib_doc($mainoutpath, $system, $archi, $qtver)
{
    echo "copying doc files in $mainoutpath for $system-$archi-qt$qtver..." . "\n";

    // create directory
    mkdirExists($mainoutpath . "doc");
    cpy_dir(LIB_PATH . "doc", $mainoutpath . "doc");
    echo "done." . "\n";
}

function distrib_bin($mainoutpath, $system, $archi, $qtver)
{
    echo "copying bin files in $mainoutpath for $system-$archi-qt$qtver..." . "\n";

    // create directory
    mkdirExists($mainoutpath . "bin");

    if ($system == "win")
    {
        copy_with_rights(LIB_PATH . "bin" . DIRECTORY_SEPARATOR . "gpnode.bat", $mainoutpath . "bin" . DIRECTORY_SEPARATOR . "gpnode.bat");
        copy_with_rights(LIB_PATH . "bin" . DIRECTORY_SEPARATOR . "gplib.bat", $mainoutpath . "bin" . DIRECTORY_SEPARATOR . "gplib.bat");
        copy_with_rights(LIB_PATH . "bin" . DIRECTORY_SEPARATOR . "gpdevice.bat", $mainoutpath . "bin" . DIRECTORY_SEPARATOR . "gpdevice.bat");
        copy_with_rights(LIB_PATH . "bin" . DIRECTORY_SEPARATOR . "gpproc.bat", $mainoutpath . "bin" . DIRECTORY_SEPARATOR . "gpproc.bat");
        copy_with_rights(LIB_PATH . "setenv.bat", $mainoutpath . "setenv.bat");
        copy_with_rights(LIB_PATH . "install.bat", $mainoutpath . "setenv.bat");
        copy_with_rights(LIB_PATH . "license.txt", $mainoutpath . "licence.txt");
    }
    else
    {
        copy_with_rights(LIB_PATH . "bin" . DIRECTORY_SEPARATOR . "gpnode", $mainoutpath . "bin" . DIRECTORY_SEPARATOR . "gpnode");
        copy_with_rights(LIB_PATH . "bin" . DIRECTORY_SEPARATOR . "gplib", $mainoutpath . "bin" . DIRECTORY_SEPARATOR . "gplib");
        copy_with_rights(LIB_PATH . "bin" . DIRECTORY_SEPARATOR . "gpdevice", $mainoutpath . "bin" . DIRECTORY_SEPARATOR . "gpdevice");
        copy_with_rights(LIB_PATH . "bin" . DIRECTORY_SEPARATOR . "gpproc", $mainoutpath . "bin" . DIRECTORY_SEPARATOR . "gpproc");
        copy_with_rights(LIB_PATH . "setenv.sh", $mainoutpath . "setenv.sh");
        copy_with_rights(LIB_PATH . "install.sh", $mainoutpath . "install.sh");
        copy_with_rights(LIB_PATH . "license.txt", $mainoutpath . "licence.txt");
        
        copy_with_rights(LIB_PATH . "share" . DIRECTORY_SEPARATOR . "gpnode_completion", $mainoutpath . "gpnode_completion");
        copy_with_rights(LIB_PATH . "share" . DIRECTORY_SEPARATOR . "gplib_completion", $mainoutpath . "gplib_completion");
        copy_with_rights(LIB_PATH . "share" . DIRECTORY_SEPARATOR . "gpdevice_completion", $mainoutpath . "gpdevice_completion");
        copy_with_rights(LIB_PATH . "share" . DIRECTORY_SEPARATOR . "gpproc_completion", $mainoutpath . "gpproc_completion");
    }
    $bin_source_path = "bin-" . $system . $archi . '-qt' . $qtver;
    cpy_dir(GUI_TOOLS_PATH . $bin_source_path, $mainoutpath . "bin");

    // copy lib_bin
    $lib_bin_dir = LIB_PATH . "distrib" . DIRECTORY_SEPARATOR . "lib_bin" . DIRECTORY_SEPARATOR . $system;
    if (file_exists($lib_bin_dir))
    {
        cpy_dir($lib_bin_dir, $mainoutpath . "bin");
    }

    echo "done." . "\n";
}

function distrib_thirdparts($mainoutpath, $system, $archi, $qtver)
{
    echo "copying thirdparts files in $mainoutpath for $system-$archi-qt$qtver..." . "\n";

    $thirdparts_dir = LIB_PATH . "distrib" . DIRECTORY_SEPARATOR . "thirdparts" . DIRECTORY_SEPARATOR . $system;
    if (file_exists($thirdparts_dir))
    {
        // create directory
        mkdirExists($mainoutpath . "thirdparts");
        cpy_dir($thirdparts_dir, $mainoutpath . "thirdparts");
    }
    echo "done." . "\n";
}
