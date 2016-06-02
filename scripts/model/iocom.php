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

require_once("io.php");
require_once("comconnect.php");

class IOCom extends IO
{
    /**
     * @brief Name of the driver to use for etablish a communication with the board
     * @var string $driverio
     */
    public $driverio;

    /**
     * @brief Array of ComConnect to give the equivalence table between hardware flow and software id flow
     * @var array|ComConnect $com_connects
     */
    public $comConnects;

    function __construct($io_device_element, $io_node_element = null)
    {
        $this->comConnects = array();

        parent::__construct($io_device_element, $io_node_element);
    }

    protected function parse_xml($io_device_element, $io_node_element)
    {
        parent::parse_xml($io_device_element, $io_node_element);

        if (isset($this->xml->com_connects))
        {
            $this->driverio = (string) $this->xml->com_connects['driverio'];

            // com_connects
            if (isset($this->xml->com_connects))
            {
                foreach ($this->xml->com_connects->com_connect as $com_connectXml)
                {
                    $this->addComConnect(new ComConnect($com_connectXml));
                }
            }
        }
    }

    public function type()
    {
        return 'iocom';
    }

    public function getXmlElement($xml, $format)
    {
        $xml_element = parent::getXmlElement($xml, $format);

        if ($format == "complete")
        {
            // com_connects
            $xml_com_connects = $xml->createElement("com_connects");

            //driverio
            $att = $xml->createAttribute('driverio');
            $att->value = $this->driverio;
            $xml_com_connects->appendChild($att);

            foreach ($this->comConnects as $comConnect)
            {
                $xml_com_connects->appendChild($comConnect->getXmlElement($xml, $format));
            }
            $xml_element->appendChild($xml_com_connects);
        }

        return $xml_element;
    }

    /** Add a comConnect to the comParam 
     *  @param ComConnect $comConnect comConnect to add to the comParam * */
    function addComConnect($comConnect)
    {
        array_push($this->comConnects, $comConnect);
    }

    /** return a reference to the comConnect with the link $link, if not found, return null
     *  @param string $link link of the comConnect to search
     *  @return ComConnect found comConnect * */
    function getComConnect($link)
    {
        foreach ($this->comConnects as $comConnect)
        {
            if ($comConnect->link == $link)
                return $comConnect;
        }
        return null;
    }
}
