<?php
/*
 * Copyright (C) 2016 Dream IP
 * 
 * This file is part of GPStudio.
 *
 * GPStudio is a free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

define("LIB_PATH", realpath(dirname(__FILE__) . "/../..") . DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH);
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH . DIRECTORY_SEPARATOR . 'scripts');
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH . DIRECTORY_SEPARATOR . 'scripts' . DIRECTORY_SEPARATOR . 'model');
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH . DIRECTORY_SEPARATOR . 'scripts' . DIRECTORY_SEPARATOR . 'system_interconnect');
set_include_path(get_include_path() . PATH_SEPARATOR . LIB_PATH . DIRECTORY_SEPARATOR . 'support');

require_once("gpstudio.php");

$options = getopt("i:");

if (array_key_exists('i', $options))
    $input_image = $options['i'];
else
    error("You should specify an input image file with -i", 1);

$path_parts = pathinfo($input_image);
if (array_key_exists('o', $options))
    $output_file = $options['o'];
else
    $output_file = dirname($input_image) . DIRECTORY_SEPARATOR . $path_parts['filename'] . ".img";

// open input image
$ext = strtolower($path_parts['extension']);
switch($ext)
{
	case "png":
		$img = imagecreatefrompng($input_image);
		break;
	case "jpg":
	case "jpeg":
		$img = imagecreatefromjpeg($input_image);
		break;
	case "gif":
		$img = imagecreatefromgif($input_image);
		break;
	case "bmp":
		$img = imagecreatefromwbmp($input_image);
		break;
	default:
		$img = NULL;
		break;
}
if($img == NULL)
	error("Cannot open image file '" . $input_image . "'", 1);

// imagefilter($img, IMG_FILTER_GRAYSCALE);

$handle = fopen($output_file, "wb");

for($y = 0; $y < imagesy($img); $y++)
{
	for($x = 0; $x < imagesx($img); $x++)
	{
		$rgb = imagecolorat($img, $x, $y);
		$r = ($rgb >> 16) & 0xFF;
		$g = ($rgb >> 8) & 0xFF;
		$b = $rgb & 0xFF;
		$gray = 0.30*$r + 0.59*$g + 0.11*$b;
		
		fwrite($handle, (int)$gray . " ");
	}
	fwrite($handle, "\n");
}

fclose($handle);
imagedestroy($img);
