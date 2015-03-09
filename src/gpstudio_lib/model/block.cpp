#include "block.h"

#include <QDebug>
#include <QStringList>

#include "io.h"
#include "process.h"

Block::Block()
{
}

Block::~Block()
{
    for(int i=0; i<_files.size(); i++) delete _files[i];
    for(int i=0; i<_params.size(); i++) delete _params[i];
    for(int i=0; i<_properties.size(); i++) delete _properties[i];
    for(int i=0; i<_flows.size(); i++) delete _flows[i];
    for(int i=0; i<_clocks.size(); i++) delete _clocks[i];
    for(int i=0; i<_ports.size(); i++) delete _ports[i];
    for(int i=0; i<_pins.size(); i++) delete _pins[i];
    for(int i=0; i<_resets.size(); i++) delete _resets[i];
}

const QString &Block::name() const
{
    return _name;
}

void Block::setName(const QString &name)
{
    _name = name;
}

bool Block::inLib() const
{
    return _inLib;
}

void Block::setInLib(bool inLib)
{
    _inLib = inLib;
}

qint32 Block::addrAbs() const
{
    return _addrAbs;
}

void Block::setAddrAbs(const qint32 &value)
{
    _addrAbs = value;
}

quint8 Block::sizeAddrRel() const
{
    return _sizeAddrRel;
}

void Block::setSizeAddrRel(const quint8 &value)
{
    _sizeAddrRel = value;
}

quint8 Block::masterCount() const
{
    return _masterCount;
}

void Block::setMasterCount(const quint8 &value)
{
    _masterCount = value;
}

const QString &Block::description() const
{
    return _description;
}

void Block::setDescription(const QString &description)
{
    _description = description;
}

QString Block::type() const
{
    return "block";
}

QList<File *> &Block::files()
{
    return _files;
}

const QList<File *> &Block::files() const
{
    return _files;
}

void Block::addFile(File *file)
{
    file->setParent(this);
    _files.append(file);
}

void Block::addFiles(const QList<File *> &files)
{
    foreach (File *file, files)
    {
        addFile(file);
    }
}

QList<Param *> &Block::params()
{
    return _params;
}

const QList<Param *> &Block::params() const
{
    return _params;
}

void Block::addParam(Param *param)
{
    param->setParent(this);
    _params.append(param);
}

void Block::addParams(const QList<Param *> &params)
{
    foreach (Param *param, params)
    {
        addParam(param);
    }
}

QList<BlockProperty *> &Block::properties()
{
    return _properties;
}

const QList<BlockProperty *> &Block::properties() const
{
    return _properties;
}

void Block::addProperty(BlockProperty *propertyEnums)
{
    propertyEnums->setParent(this);
    _properties.append(propertyEnums);
}

void Block::addProperties(const QList<BlockProperty *> &properties)
{
    foreach (BlockProperty *property, properties)
    {
        addProperty(property);
    }
}

QList<Flow *> &Block::flows()
{
    return _flows;
}

const QList<Flow *> &Block::flows() const
{
    return _flows;
}

void Block::addFlow(Flow *flow)
{
    flow->setParent(this);
    _flows.append(flow);
}

void Block::addFlows(const QList<Flow *> &flows)
{
    foreach (Flow *flow, flows)
    {
        addFlow(flow);
    }
}

QList<Clock *> &Block::clocks()
{
    return _clocks;
}

const QList<Clock *> &Block::clocks() const
{
    return _clocks;
}

void Block::addClock(Clock *clock)
{
    clock->setParent(this);
    _clocks.append(clock);
}

void Block::addClocks(const QList<Clock *> &clocks)
{
    foreach (Clock *clock, clocks)
    {
        addClock(clock);
    }
}

QList<Port *> &Block::ports()
{
    return _ports;
}

const QList<Port *> &Block::ports() const
{
    return _ports;
}

void Block::addPort(Port *port)
{
    port->setParent(this);
    _ports.append(port);
}

void Block::addPorts(const QList<Port *> &ports)
{
    foreach (Port *port, ports)
    {
        addPort(port);
    }
}

QList<Pin *> &Block::pins()
{
    return _pins;
}

const QList<Pin *> &Block::pins() const
{
    return _pins;
}

void Block::addPin(Pin *pin)
{
    pin->setParent(this);
    _pins.append(pin);
}

void Block::addPins(const QList<Pin *> &pins)
{
    foreach (Pin *pin, pins)
    {
        addPin(pin);
    }
}

QList<Reset *> &Block::resets()
{
    return _resets;
}

const QList<Reset *> &Block::resets() const
{
    return _resets;
}

void Block::addReset(Reset *reset)
{
    reset->setParent(this);
    _resets.append(reset);
}

void Block::addResets(const QList<Reset *> &resets)
{
    foreach (Reset *reset, resets)
    {
        addReset(reset);
    }
}

Block *Block::fromNodeGenerated(const QDomElement &domElement)
{
    Block *block=NULL;

    QStringList typeBlock;
    typeBlock << "process" << "io";
    switch (typeBlock.indexOf(domElement.attribute("type")))
    {
    case 0:
        block = new Process();
        break;
    case 1:
        block = new IO();
        break;
    default:
        block = new Block();
        break;
    }

    if(block)
    {
        bool ok=false;

        block->setName(domElement.attribute("name","no_name"));

        block->setInLib((domElement.attribute("in_lib","")=="1" || domElement.attribute("in_lib","")=="true"));

        int addrAbs = domElement.attribute("addr_abs","-1").toInt(&ok);
        if(ok) block->setAddrAbs(addrAbs); else block->setAddrAbs(-1);

        int sizeAddrRel = domElement.attribute("size_addr_rel","0").toInt(&ok);
        if(ok && sizeAddrRel>=0) block->setSizeAddrRel(sizeAddrRel); else block->setSizeAddrRel(0);

        int masterCount = domElement.attribute("master_count","0").toInt(&ok);
        if(ok && masterCount>=0) block->setMasterCount(masterCount); else block->setMasterCount(0);

        block->setDescription(domElement.attribute("desc",""));

        QDomNode n = domElement.firstChild();
        while(!n.isNull())
        {
            QDomElement e = n.toElement();
            if(!e.isNull())
            {
                if(e.tagName()=="files") block->addFiles(File::listFromNodeGenerated(e));
                if(e.tagName()=="params") block->addParams(Param::listFromNodeGenerated(e));
                if(e.tagName()=="properties") block->addProperties(BlockProperty::listFromNodeGenerated(e));
                if(e.tagName()=="flows") block->addFlows(Flow::listFromNodeGenerated(e));
                if(e.tagName()=="clocks") block->addClocks(Clock::listFromNodeGenerated(e));
                if(e.tagName()=="ports") block->addPorts(Port::listFromNodeGenerated(e));
                if(e.tagName()=="pins") block->addPins(Pin::listFromNodeGenerated(e));
                if(e.tagName()=="resets") block->addResets(Reset::listFromNodeGenerated(e));
            }
            n = n.nextSibling();
        }
    }

    // block specific part TODO

    return block;
}

QList<Block *> Block::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<Block *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="block") list.append(Block::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
