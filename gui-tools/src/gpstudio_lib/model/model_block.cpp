/****************************************************************************
** Copyright (C) 2016 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#include "model_block.h"

#include <QDebug>
#include <QStringList>

#include "model_io.h"
#include "model_iocom.h"
#include "model_process.h"
#include "model_piblock.h"
#include "model_fiblock.h"
#include "model_ciblock.h"

ModelBlock::ModelBlock()
{
    _pos = QPoint(0, 0);
}

ModelBlock::ModelBlock(const ModelBlock &modelBlock)
{
    _name = modelBlock._name;
    _inLib = modelBlock._inLib;
    _driver = modelBlock._driver;
    _categ = modelBlock._categ;
    _addrAbs = modelBlock._addrAbs;
    _sizeAddrRel = modelBlock._sizeAddrRel;
    _masterCount = modelBlock._masterCount;
    _pos = modelBlock._pos;
    _description = modelBlock._description;

    for(int i=0; i<modelBlock._files.size(); i++)
        addFile(new ModelFile(*modelBlock._files[i]));
    for(int i=0; i<modelBlock._params.size(); i++)
        addParam(new ModelParam(*modelBlock._params[i]));
    for(int i=0; i<modelBlock._properties.size(); i++)
        addProperty(new ModelProperty(*modelBlock._properties[i]));
    for(int i=0; i<modelBlock._flows.size(); i++)
        addFlow(new ModelFlow(*modelBlock._flows[i]));
    for(int i=0; i<modelBlock._clocks.size(); i++)
        addClock(new ModelClock(*modelBlock._clocks[i]));
    for(int i=0; i<modelBlock._ports.size(); i++)
        addPort(new ModelPort(*modelBlock._ports[i]));
    for(int i=0; i<modelBlock._pins.size(); i++)
        addPin(new ModelPin(*modelBlock._pins[i]));
    for(int i=0; i<modelBlock._resets.size(); i++)
        addReset(new ModelReset(*modelBlock._resets[i]));
}

ModelBlock::~ModelBlock()
{
    for(int i=0; i<_files.size(); i++)
        delete _files[i];
    for(int i=0; i<_params.size(); i++)
        delete _params[i];
    for(int i=0; i<_properties.size(); i++)
        delete _properties[i];
    for(int i=0; i<_flows.size(); i++)
        delete _flows[i];
    for(int i=0; i<_clocks.size(); i++)
        delete _clocks[i];
    for(int i=0; i<_ports.size(); i++)
        delete _ports[i];
    for(int i=0; i<_pins.size(); i++)
        delete _pins[i];
    for(int i=0; i<_resets.size(); i++)
        delete _resets[i];
}

const QString &ModelBlock::name() const
{
    return _name;
}

void ModelBlock::setName(const QString &name)
{
    _name = name;
}

bool ModelBlock::inLib() const
{
    return _inLib;
}

void ModelBlock::setInLib(bool inLib)
{
    _inLib = inLib;
}

const QString &ModelBlock::driver() const
{
    return _driver;
}

void ModelBlock::setDriver(const QString &driver)
{
    _driver = driver;
}

const QString &ModelBlock::categ() const
{
    return _categ;
}

void ModelBlock::setCateg(const QString &categ)
{
    _categ = categ;
}

qint32 ModelBlock::addrAbs() const
{
    return _addrAbs;
}

void ModelBlock::setAddrAbs(const qint32 &value)
{
    _addrAbs = value;
}

quint8 ModelBlock::sizeAddrRel() const
{
    return _sizeAddrRel;
}

void ModelBlock::setSizeAddrRel(const quint8 &value)
{
    _sizeAddrRel = value;
}

quint8 ModelBlock::masterCount() const
{
    return _masterCount;
}

void ModelBlock::setMasterCount(const quint8 &value)
{
    _masterCount = value;
}

const QPoint &ModelBlock::pos() const
{
    return _pos;
}

void ModelBlock::setPos(const QPoint &pos)
{
    _pos = pos;
}

const QString &ModelBlock::description() const
{
    return _description;
}

void ModelBlock::setDescription(const QString &description)
{
    _description = description;
}

QString ModelBlock::type() const
{
    return "block";
}

QList<ModelFile *> &ModelBlock::files()
{
    return _files;
}

const QList<ModelFile *> &ModelBlock::files() const
{
    return _files;
}

void ModelBlock::addFile(ModelFile *file)
{
    file->setParent(this);
    _files.append(file);
}

void ModelBlock::addFiles(const QList<ModelFile *> &files)
{
    foreach (ModelFile *file, files)
    {
        addFile(file);
    }
}

ModelFile *ModelBlock::getFile(const QString &name) const
{
    for(int i=0; i<this->files().size(); i++)
    {
        ModelFile *file = this->files().at(i);
        if(file->name()==name)
            return file;
    }
    return NULL;
}

QList<ModelParam *> &ModelBlock::params()
{
    return _params;
}

const QList<ModelParam *> &ModelBlock::params() const
{
    return _params;
}

void ModelBlock::addParam(ModelParam *param)
{
    param->setParent(this);
    _params.append(param);
}

void ModelBlock::addParams(const QList<ModelParam *> &params)
{
    foreach (ModelParam *param, params)
    {
        addParam(param);
    }
}

ModelParam *ModelBlock::getParam(const QString &name) const
{
    for(int i=0; i<this->params().size(); i++)
    {
        ModelParam *param = this->params().at(i);
        if(param->name()==name)
            return param;
    }
    return NULL;
}

QList<ModelProperty *> &ModelBlock::properties()
{
    return _properties;
}

const QList<ModelProperty *> &ModelBlock::properties() const
{
    return _properties;
}

void ModelBlock::addProperty(ModelProperty *property)
{
    property->setParent(this);
    _properties.append(property);
}

void ModelBlock::addProperties(const QList<ModelProperty *> &properties)
{
    foreach (ModelProperty *property, properties)
    {
        addProperty(property);
    }
}

ModelProperty *ModelBlock::getBlockProperty(const QString &name) const
{
    for(int i=0; i<this->properties().size(); i++)
    {
        ModelProperty *blockProperty = this->properties().at(i);
        if(blockProperty->name()==name)
            return blockProperty;
    }
    return NULL;
}

QList<ModelFlow *> &ModelBlock::flows()
{
    return _flows;
}

const QList<ModelFlow *> &ModelBlock::flows() const
{
    return _flows;
}

void ModelBlock::addFlow(ModelFlow *flow)
{
    flow->setParent(this);
    _flows.append(flow);
}

void ModelBlock::addFlows(const QList<ModelFlow *> &flows)
{
    foreach (ModelFlow *flow, flows)
    {
        addFlow(flow);
    }
}

ModelFlow *ModelBlock::getFlow(const QString &name) const
{
    for(int i=0; i<this->flows().size(); i++)
    {
        ModelFlow *flow = this->flows().at(i);
        if(flow->name()==name)
            return flow;
    }
    return NULL;
}

QList<ModelClock *> &ModelBlock::clocks()
{
    return _clocks;
}

const QList<ModelClock *> &ModelBlock::clocks() const
{
    return _clocks;
}

void ModelBlock::addClock(ModelClock *clock)
{
    clock->setParent(this);
    _clocks.append(clock);
}

void ModelBlock::addClocks(const QList<ModelClock *> &clocks)
{
    foreach (ModelClock *clock, clocks)
    {
        addClock(clock);
    }
}

ModelClock *ModelBlock::getClock(const QString &name) const
{
    for(int i=0; i<this->clocks().size(); i++)
    {
        ModelClock *clock = this->clocks().at(i);
        if(clock->name()==name)
            return clock;
    }
    return NULL;
}

QList<ModelPort *> &ModelBlock::ports()
{
    return _ports;
}

const QList<ModelPort *> &ModelBlock::ports() const
{
    return _ports;
}

void ModelBlock::addPort(ModelPort *port)
{
    port->setParent(this);
    _ports.append(port);
}

void ModelBlock::addPorts(const QList<ModelPort *> &ports)
{
    foreach (ModelPort *port, ports)
    {
        addPort(port);
    }
}

ModelPort *ModelBlock::getPort(const QString &name) const
{
    for(int i=0; i<this->ports().size(); i++)
    {
        ModelPort *port = this->ports().at(i);
        if(port->name()==name)
            return port;
    }
    return NULL;
}

QList<ModelPin *> &ModelBlock::pins()
{
    return _pins;
}

const QList<ModelPin *> &ModelBlock::pins() const
{
    return _pins;
}

void ModelBlock::addPin(ModelPin *pin)
{
    pin->setParent(this);
    _pins.append(pin);
}

void ModelBlock::addPins(const QList<ModelPin *> &pins)
{
    foreach (ModelPin *pin, pins)
    {
        addPin(pin);
    }
}

ModelPin *ModelBlock::getPin(const QString &name) const
{
    for(int i=0; i<this->pins().size(); i++)
    {
        ModelPin *pin = this->pins().at(i);
        if(pin->name()==name)
            return pin;
    }
    return NULL;
}

QList<ModelReset *> &ModelBlock::resets()
{
    return _resets;
}

const QList<ModelReset *> &ModelBlock::resets() const
{
    return _resets;
}

void ModelBlock::addReset(ModelReset *reset)
{
    reset->setParent(this);
    _resets.append(reset);
}

void ModelBlock::addResets(const QList<ModelReset *> &resets)
{
    foreach (ModelReset *reset, resets)
    {
        addReset(reset);
    }
}

ModelReset *ModelBlock::getReset(const QString &name) const
{
    for(int i=0; i<this->resets().size(); i++)
    {
        ModelReset *reset = this->resets().at(i);
        if(reset->name()==name)
            return reset;
    }
    return NULL;
}

ModelBlock *ModelBlock::fromNodeGenerated(const QDomElement &domElement, ModelBlock *block)
{
    if(block==NULL)
        block = new ModelBlock();

    bool ok=false;

    block->setName(domElement.attribute("name","no_name"));

    block->setInLib((domElement.attribute("inlib","")=="1" || domElement.attribute("inlib","")=="true"));

    block->setDriver(domElement.attribute("driver",""));
    block->setCateg(domElement.attribute("categ",""));

    QPoint pos;
    int xPos = domElement.attribute("x_pos","-1").toInt(&ok);
    if(ok)
        pos.setX(xPos);
    else
        pos.setX(-1);

    int yPos = domElement.attribute("y_pos","-1").toInt(&ok);
    if(ok)
        pos.setY(yPos);
    else
        pos.setY(-1);
    block->setPos(pos);

    int addrAbs = domElement.attribute("addr_abs","-1").toInt(&ok);
    if(ok)
        block->setAddrAbs(addrAbs);
    else
        block->setAddrAbs(-1);

    int sizeAddrRel = domElement.attribute("pi_size_addr_rel","0").toInt(&ok);
    if(ok && sizeAddrRel>=0)
        block->setSizeAddrRel(sizeAddrRel);
    else
        block->setSizeAddrRel(0);

    int masterCount = domElement.attribute("master_count","0").toInt(&ok);
    if(ok && masterCount>=0)
        block->setMasterCount(masterCount);
    else
        block->setMasterCount(0);

    block->setDescription(domElement.attribute("desc",""));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="files")
                block->addFiles(ModelFile::listFromNodeGenerated(e));
            if(e.tagName()=="params")
                block->addParams(ModelParam::listFromNodeGenerated(e));
            if(e.tagName()=="properties")
                block->addProperties(ModelProperty::listFromNodeGenerated(e));
            if(e.tagName()=="flows")
                block->addFlows(ModelFlow::listFromNodeGenerated(e));
            if(e.tagName()=="clocks")
                block->addClocks(ModelClock::listFromNodeGenerated(e));
            if(e.tagName()=="resets")
                block->addResets(ModelReset::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return block;
}

ModelBlock *ModelBlock::fromNodeDef(const QDomElement &domElement, ModelBlock *block)
{
    bool ok;

    if(block==NULL)
        block = new ModelBlock();

    block->setName(domElement.attribute("name","no_name"));
    block->setDriver(domElement.attribute("driver",""));

    QPoint pos;
    int xPos = domElement.attribute("x_pos","-1").toInt(&ok);
    if(ok)
        pos.setX(xPos);
    else
        pos.setX(-1);

    int yPos = domElement.attribute("y_pos","-1").toInt(&ok);
    if(ok)
        pos.setY(yPos);
    else
        pos.setY(-1);
    block->setPos(pos);

    return block;
}

QList<ModelBlock *> ModelBlock::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelBlock *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            ModelBlock *block=NULL;
            QString typeBlock = e.attribute("type");
            if(e.tagName()=="block")
            {
                if(typeBlock=="process")
                    block = ModelProcess::fromNodeGenerated(e);
                if(typeBlock=="io")
                    block = ModelIO::fromNodeGenerated(e);
                if(typeBlock=="iocom")
                    block = ModelIOCom::fromNodeGenerated(e);
                if(typeBlock=="pi")
                    block = ModelPIBlock::fromNodeGenerated(e);
                if(typeBlock=="fi")
                    block = ModelFIBlock::fromNodeGenerated(e);
                if(typeBlock=="ci")
                    block = ModelCIBlock::fromNodeGenerated(e);
                if(block==NULL)
                    block = ModelBlock::fromNodeGenerated(e);

                list.append(block);
            }
        }
        n = n.nextSibling();
    }
    return list;
}

QList<ModelBlock *> ModelBlock::listFromNodeDef(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelBlock *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            ModelBlock *block=NULL;
            if(e.tagName()=="process")
                block = ModelProcess::fromNodeDef(e);
            if(e.tagName()=="io")
                block = ModelIO::fromNodeDef(e);
            if(e.tagName()=="iocom")
                block = ModelIOCom::fromNodeDef(e);
            if(block==NULL)
                block = ModelBlock::fromNodeGenerated(e);

            list.append(block);
        }
        n = n.nextSibling();
    }
    return list;
}

QDomElement ModelBlock::toXMLElement(QDomDocument &doc, const QDomElement &other)
{
    QDomElement element;
    if(other.isNull())
        element = doc.createElement("process");
    else
        element = other;

    element.setAttribute("name", _name);
    element.setAttribute("driver", _driver);
    element.setAttribute("inlib", _inLib ? "true" : "false");
    element.setAttribute("x_pos", _pos.x());
    element.setAttribute("y_pos", _pos.y());

    return element;
}
