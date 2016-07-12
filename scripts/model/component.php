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

require_once("file.php");
require_once("param.php");
require_once("flow.php");
require_once("clock.php");
require_once("reset.php");
require_once("port.php");
require_once("interfacebus.php");
require_once("attribute.php");
require_once("pin.php");
require_once("port.php");

/**
 * Component is the the definition of hardware components. It could be
 * used in a block to indicate the inclusion of the block or in the
 * component library to define them.
 * @brief Component is the the definition of hardware components.
 * @see Block
 * @ingroup base
 */
class Component
{
    /**
     * @brief Name of the component
     * @var string $name
     */
    public $name;

    /**
     * @brief Path where the root of files and define of the component is putted
     * @var string $path
     */
    public $path;

    /**
     * @brief Specify the categorie of the component eg : communication, imagesensor, descriptor...
     * @var string $categ
     */
    public $categ;

    /**
     * @brief Description of the flow (optional)
     * @var string $desc
     */
    public $desc;

    /**
     * @brief Array of parameters class (can be Generic or dynamics parameter on BI)
     * @var array|Param $params
     */
    public $params;

    /**
     * @brief Array of files whith define the implementation of the component
     * @var array|File $files
     */
    public $files;

    /**
     * @brief Array of flows in the component can be input flow or output
     * @var array|Flow $flows
     */
    public $flows;

    /**
     * @brief Array of clocks to drive the component
     * @var array|Clock $clocks
     */
    public $clocks;

    /**
     * @brief Array of resets, can be different type of resets
     * @var array|Reset $resets
     */
    public $resets;

    /**
     * @brief Array of children components
     * @var array|Component $components
     */
    public $components;

    /**
     * @brief Parent components, null if the component does not have a parent
     * @var Component $parentComponent
     */
    public $parentComponent;

    protected $xml;

    /**
     * @brief constructor of Component
     * 
     * Initialise all the internal members
     */
    function __construct()
    {
        $this->params = array();
        $this->files = array();
        $this->flows = array();
        $this->clocks = array();
        $this->resets = array();
        $this->interfaces = array();
        $this->attributes = array();
        $this->components = array();
        
        $this->parentComponent = NULL;
    }

    /**
     * @brief Add a parameter to the component 
     * @param Param $param parameter to add to the component
     */
    function addParam($param)
    {
        $param->parentBlock = $this;
        array_push($this->params, $param);
    }

    /**
     * @brief return a reference to the parameter with the name $name, if not found, return null
     * @param string $name name of the parameter to search
     * @param bool $casesens take care or not of the case of the name
     * @return Param found parameter
     */
    function getParam($name, $casesens = true)
    {
        if ($casesens)
        {
            foreach ($this->params as $param)
            {
                if ($param->name == $name)
                    return $param;
            }
        }
        else
        {
            foreach ($this->params as $param)
            {
                if (strcasecmp($param->name, $name) == 0)
                    return $param;
            }
        }
        return null;
    }

    /**
     * @brief delete a param from his name
     * @param string $name name of the param to delete
     */
    function delParam($name)
    {
        $i = 0;
        foreach ($this->params as $param)
        {
            if ($param->name == $name)
            {
                unset($this->params[$i]);
                return;
            }
            $i++;
        }
        return null;
    }

    /**
     * @brief Add a file to the component 
     * @param File $file file to add to the component
     */
    function addFile($file)
    {
        $file->parentBlock = $this;
        array_push($this->files, $file);
    }

    /**
     * @brief return a reference to the file with the name $name, if not found,
     * return null
     * @param string $name name of the file to search
     * @return File found file
     */
    function getFile($name)
    {
        foreach ($this->files as $file)
        {
            if ($file->name == $name)
                return $file;
        }
        return null;
    }

    /**
     * @brief return a reference to the file with the path $path, if not found,
     * return null
     * @param string $path path of the file to search
     * @return File found file
     */
    function getFileByPath($path)
    {
        foreach ($this->files as $file)
        {
            if ($file->path == $path)
                return $file;
        }
        return null;
    }

    /**
     * @brief delete a file from his path
     * @param string $path path of the file to delete
     */
    function delFileByPath($path)
    {
        $i = 0;
        foreach ($this->files as $file)
        {
            if ($file->path == $path)
            {
                unset($this->files[$i]);
                return;
            }
            $i++;
        }
        return null;
    }

    /**
     * @brief Add a flow to the component 
     * @param Flow $flow flow to add to the component
     */
    function addFlow($flow)
    {
        $flow->parentBlock = $this;
        array_push($this->flows, $flow);
    }

    /**
     * @brief return a reference to the flow with the name $name, if not found,
     * return null
     * @param string $name name of the flow to search
     * @param bool $casesens take care or not of the case of the name
     * @return Flow found flow
     */
    function getFlow($name, $casesens = true)
    {
        if ($casesens)
        {
            foreach ($this->flows as $flow)
            {
                if ($flow->name == $name)
                    return $flow;
            }
        }
        else
        {
            foreach ($this->flows as $flow)
            {
                if (strcasecmp($flow->name, $name) == 0)
                    return $flow;
            }
        }
        return null;
    }

    /**
     * @brief delete a flow from his name
     * @param string $name name of the flow to delete
     */
    function delFlow($name)
    {
        $i = 0;
        foreach ($this->flows as $flow)
        {
            if ($flow->name == $name)
            {
                unset($this->flows[$i]);
                return;
            }
            $i++;
        }
        return null;
    }

    /**
     * @brief Add a clock to the component 
     * @param Clock $clock clock to add to the component
     */
    function addClock($clock)
    {
        $clock->parentBlock = $this;
        array_push($this->clocks, $clock);
    }

    /**
     * @brief return a reference to the clock with the name $name, if not found,
     * return null
     * @param string $name name of the clock to search
     * @param bool $casesens take care or not of the case of the name
     * @return Clock found clock
     */
    function getClock($name, $casesens = true)
    {
        if ($casesens)
        {
            foreach ($this->clocks as $clock)
            {
                if ($clock->name == $name)
                    return $clock;
            }
        }
        else
        {
            foreach ($this->clocks as $clock)
            {
                if (strcasecmp($clock->name, $name) == 0)
                    return $clock;
            }
        }
        return null;
    }

    /**
     * @brief delete a clock from his name
     * @param string $name name of the clock to delete
     */
    function delClock($name)
    {
        $i = 0;
        foreach ($this->clocks as $clock)
        {
            if ($clock->name == $name)
            {
                unset($this->clocks[$i]);
                return;
            }
            $i++;
        }
        return null;
    }

    /**
     * @brief Add a reset to the component 
     * @param Reset $reset reset to add to the component
     */
    function addReset($reset)
    {
        $reset->parentBlock = $this;
        array_push($this->resets, $reset);
    }

    /**
     * @brief return a reference to the reset with the name $name, if not found,
     * return null
     * @param string $name name of the reset to search
     * @param bool $casesens take care or not of the case of the name
     * @return Reset found reset
     */
    function getReset($name, $casesens = true)
    {
        if ($casesens)
        {
            foreach ($this->resets as $reset)
            {
                if ($reset->name == $name)
                    return $reset;
            }
        }
        else
        {
            foreach ($this->resets as $reset)
            {
                if (strcasecmp($reset->name, $name) == 0)
                    return $reset;
            }
        }
        return null;
    }

    /**
     * @brief delete a reset from his name
     * @param string $name name of the reset to delete
     */
    function delReset($name)
    {
        $i = 0;
        foreach ($this->resets as $reset)
        {
            if ($reset->name == $name)
            {
                unset($this->resets[$i]);
                return;
            }
            $i++;
        }
        return null;
    }

    /** @brief Add an InterfaceBus to the block 
     *  @param InterfaceBus $interface interface to add to the block
     */
    function addInterface($interface)
    {
        $interface->parentBlock = $this;
        array_push($this->interfaces, $interface);
    }

    /** @brief return a reference to the interface with the name $name, if not
     * found, return null
     *  @param string $name name of the interface to search
     *  @param bool $casesens take care or not of the case of the name
     *  @return InterfaceBus found interface
     */
    function getInterface($name, $casesens = true)
    {
        if ($casesens)
        {
            foreach ($this->interfaces as $interface)
            {
                if ($interface->name == $name)
                    return $interface;
            }
        }
        else
        {
            foreach ($this->interfaces as $interface)
            {
                if (strcasecmp($interface->name, $name) == 0)
                    return $interface;
            }
        }
        return null;
    }

    /** @brief Add an attribute to the toolchain 
     *  @param Attribute $attribute attribute to add to the block
     */
    function addAttribute($attribute)
    {
        array_push($this->attributes, $attribute);
    }

    /** @brief return a reference to the attribute with the name $name, if not
     * found, return null
     *  @param string $name name of the attribute enum to search
     *  @param bool $casesens take care or not of the case of the name
     *  @return Attribute found attribute
     */
    function getAttribute($name, $casesens = true)
    {
        if ($casesens)
        {
            foreach ($this->attributes as $attribute)
            {
                if ($attribute->name == $name)
                    return $attribute;
            }
        }
        else
        {
            foreach ($this->attributes as $attribute)
            {
                if (strcasecmp($attribute->name, $name) == 0)
                    return $attribute;
            }
        }
        return null;
    }

    /** @brief Add a component to the toolchain 
     *  @param Component $component attribute to add to the block
     */
    function addComponent($component)
    {
        $component->parentComponent = $this;
        array_push($this->components, $component);
    }

    /** @brief return a reference to the component with the name $name, if not
     * found, return null
     *  @param string $name name of the component enum to search
     *  @param bool $casesens take care or not of the case of the name
     *  @return Component found component
     */
    function getComponent($name, $casesens = true)
    {
        if ($casesens)
        {
            foreach ($this->attributes as $attribute)
            {
                if ($attribute->name == $name)
                    return $attribute;
            }
        }
        else
        {
            foreach ($this->attributes as $attribute)
            {
                if (strcasecmp($attribute->name, $name) == 0)
                    return $attribute;
            }
        }
        return null;
    }

    /** @brief return a reference to the instance with the name $name, if not
     * found, return null
     *  @param string $name name of the instance to search
     *  @param bool $casesens take care or not of the case of the name
     *  @return mixed found instance
     */
    function getInstance($name, $casesens = true)
    {
        $instance = $this->getAttribute($name, $casesens);
        if ($instance != NULL)
            return $instance;
        $instance = $this->getClock($name, $casesens);
        if ($instance != NULL)
            return $instance;
        $instance = $this->getFileByPath($name);
        if ($instance != NULL)
            return $instance;
        $instance = $this->getFlow($name, $casesens);
        if ($instance != NULL)
            return $instance;
        $instance = $this->getParam($name, $casesens);
        if ($instance != NULL)
            return $instance;
        $instance = $this->getPropertyPath($name, $casesens);
        if ($instance != NULL)
            return $instance;
        $instance = $this->getReset($name, $casesens);
        if ($instance != NULL)
            return $instance;

        if ($this->type() == "io" or $this->type() == "iocom")
        {
            $instance = $this->getExtPort($name, $casesens);
            if ($instance != NULL)
                return $instance;
        }

        return null;
    }

    /**
     * @brief internal function to fill this instance from input xml structure
     * 
     * Can be call only from this node into the constructor
     * @param SimpleXMLElement $xml xml element to parse
     */
    protected function parse_xml()
    {
        $this->categ = (string) $this->xml['categ'];
        $this->desc = (string) $this->xml['desc'];

        // files
        if (isset($this->xml->files))
        {
            foreach ($this->xml->files->file as $fileXml)
            {
                $this->addFile(new File($fileXml));
            }
        }

        // params
        if (isset($this->xml->params))
        {
            foreach ($this->xml->params->param as $paramXml)
            {
                $this->addParam(new Param($paramXml));
            }
        }

        // flows
        if (isset($this->xml->flows))
        {
            foreach ($this->xml->flows->flow as $flowXml)
            {
                $this->addFlow(new Flow($flowXml));
            }
        }

        // clocks
        if (isset($this->xml->clocks))
        {
            foreach ($this->xml->clocks->clock as $clockXml)
            {
                $this->addClock(new Clock($clockXml));
            }
        }

        // resets
        if (isset($this->xml->resets))
        {
            foreach ($this->xml->resets->reset as $resetXml)
            {
                $this->addReset(new Reset($resetXml));
            }
        }

        // components
        if (isset($this->xml->components))
        {
            foreach ($this->xml->components->component as $componentXml)
            {
                $this->addComponent(new Reset($componentXml));
            }
        }
    }

    /**
     * @brief Returns the type of the block as string, redefined by children.
     * @return string type of the block.
     */
    public function type()
    {
        return 'component';
    }

    /**
     * @brief permits to output this instance
     * 
     * Return a formated node for the node_generated file. This method call all
     * the children getXmlElement to add into this node.
     * @param DOMDocument $xml reference of the output xml document
     * @param string $format desired output file format
     * @return DOMElement xml element corresponding to this current instance
     */
    public function getXmlElement($xml, $format)
    {
        $xml_element = $xml->createElement("component");

        // name
        $att = $xml->createAttribute('name');
        $att->value = $this->name;
        $xml_element->appendChild($att);

        // desc
        $att = $xml->createAttribute('desc');
        $att->value = $this->desc;
        $xml_element->appendChild($att);

        // files
        if (!empty($this->files))
        {
            $xml_files = $xml->createElement("files");
            foreach ($this->files as $file)
            {
                $xml_files->appendChild($file->getXmlElement($xml, $format));
            }
            $xml_element->appendChild($xml_files);
        }

        // flows
        if (!empty($this->flows))
        {
            $xml_flows = $xml->createElement("flows");
            foreach ($this->flows as $flow)
            {
                if ($flow->type == "in" or $flow->type == "out")
                {
                    $xml_flows->appendChild($flow->getXmlElement($xml, $format));
                    $count++;
                }
            }
            $xml_element->appendChild($xml_flows);
        }

        // params
        if (!empty($this->params))
        {
            $xml_params = $xml->createElement("params");
            foreach ($this->params as $param)
            {
                $xml_params->appendChild($param->getXmlElement($xml, $format));
                $count++;
            }
            $xml_element->appendChild($xml_params);
        }

        // clocks
        if (!empty($this->clocks))
        {
            $xml_clocks = $xml->createElement("clocks");
            foreach ($this->clocks as $clock)
            {
                $xml_clocks->appendChild($clock->getXmlElement($xml, $format));
            }
            $xml_element->appendChild($xml_clocks);
        }

        // resets
        if (!empty($this->resets))
        {
            $xml_resets = $xml->createElement("resets");
            foreach ($this->resets as $reset)
            {
                $xml_resets->appendChild($reset->getXmlElement($xml, $format));
            }
            $xml_element->appendChild($xml_resets);
        }

        // components
        if (!empty($this->components))
        {
            $xml_components = $xml->createElement("components");
            foreach ($this->components as $component)
            {
                $xml_components->appendChild($component->getXmlElement($xml, $format));
            }
            $xml_element->appendChild($xml_components);
        }

        return $xml_element;
    }
}
