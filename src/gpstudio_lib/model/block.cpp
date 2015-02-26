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
    _files.append(file);
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
    _params.append(param);
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
    _flows.append(flow);
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
    _clocks.append(clock);
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
    _ports.append(port);
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
    _pins.append(pin);
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
    _resets.append(reset);
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

        // files
        const QDomNodeList &filesNodeList = domElement.elementsByTagName("files");
        for(unsigned int i=0; i<filesNodeList.length(); i++)
        {
            const QDomElement &filesNode = filesNodeList.at(i).toElement();
            const QDomNodeList &fileNodeList = filesNode.elementsByTagName("file");
            for(unsigned int j=0; j<fileNodeList.length(); j++)
            {
                const QDomElement &fileNode = fileNodeList.at(j).toElement();
                File *file = File::fromNodeGenerated(fileNode);
                block->addFile(file);
            }
        }

        // params
        const QDomNodeList &paramsNodeList = domElement.elementsByTagName("params");
        for(unsigned int i=0; i<paramsNodeList.length(); i++)
        {
            const QDomElement &paramsNode = paramsNodeList.at(i).toElement();
            const QDomNodeList &paramNodeList = paramsNode.elementsByTagName("param");
            for(unsigned int j=0; j<paramNodeList.length(); j++)
            {
                const QDomElement &paramNode = paramNodeList.at(j).toElement();
                Param *param = Param::fromNodeGenerated(paramNode);
                block->addParam(param);
            }
        }

        // flows
        const QDomNodeList &flowsNodeList = domElement.elementsByTagName("flows");
        for(unsigned int i=0; i<flowsNodeList.length(); i++)
        {
            const QDomElement &flowsNode = flowsNodeList.at(i).toElement();
            const QDomNodeList &flowNodeList = flowsNode.elementsByTagName("flow");
            for(unsigned int j=0; j<flowNodeList.length(); j++)
            {
                const QDomElement &flowNode = flowNodeList.at(j).toElement();
                Flow *flow = Flow::fromNodeGenerated(flowNode);
                block->addFlow(flow);
            }
        }

        // clocks
        const QDomNodeList &clocksNodeList = domElement.elementsByTagName("clocks");
        for(unsigned int i=0; i<clocksNodeList.length(); i++)
        {
            const QDomElement &clocksNode = clocksNodeList.at(i).toElement();
            const QDomNodeList &clockNodeList = clocksNode.elementsByTagName("clock");
            for(unsigned int j=0; j<clockNodeList.length(); j++)
            {
                const QDomElement &clockNode = clockNodeList.at(j).toElement();
                Clock *clock = Clock::fromNodeGenerated(clockNode);
                block->addClock(clock);
            }
        }

        // ports
        const QDomNodeList &portsNodeList = domElement.elementsByTagName("ports");
        for(unsigned int i=0; i<portsNodeList.length(); i++)
        {
            const QDomElement &portsNode = portsNodeList.at(i).toElement();
            const QDomNodeList &portNodeList = portsNode.elementsByTagName("port");
            for(unsigned int j=0; j<portNodeList.length(); j++)
            {
                const QDomElement &portNode = portNodeList.at(j).toElement();
                Port *port = Port::fromNodeGenerated(portNode);
                block->addPort(port);
            }
        }

        // pins
        const QDomNodeList &pinsNodeList = domElement.elementsByTagName("pins");
        for(unsigned int i=0; i<pinsNodeList.length(); i++)
        {
            const QDomElement &pinsNode = pinsNodeList.at(i).toElement();
            const QDomNodeList &pinNodeList = pinsNode.elementsByTagName("pin");
            for(unsigned int j=0; j<pinNodeList.length(); j++)
            {
                const QDomElement &pinNode = pinNodeList.at(j).toElement();
                Pin *pin = Pin::fromNodeGenerated(pinNode);
                block->addPin(pin);
            }
        }

        // resets
        const QDomNodeList &resetsNodeList = domElement.elementsByTagName("resets");
        for(unsigned int i=0; i<resetsNodeList.length(); i++)
        {
            const QDomElement &resetsNode = resetsNodeList.at(i).toElement();
            const QDomNodeList &resetNodeList = resetsNode.elementsByTagName("reset");
            for(unsigned int j=0; j<resetNodeList.length(); j++)
            {
                const QDomElement &resetNode = resetNodeList.at(j).toElement();
                Reset *reset = Reset::fromNodeGenerated(resetNode);
                block->addReset(reset);
            }
        }
    }

    // block specific part TODO

    return block;
}
