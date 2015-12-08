#ifndef BLOCK_H
#define BLOCK_H

#include "gpstudio_lib_common.h"

#include <QDomElement>
#include <QString>
#include <QList>

#include "file.h"
#include "param.h"
#include "blockproperty.h"
#include "flow.h"
#include "clock.h"
#include "port.h"
#include "pin.h"
#include "reset.h"

class GPSTUDIO_LIB_EXPORT Block
{
protected:
    Block();

public:
    virtual ~Block();

    const QString &name() const;
    void setName(const QString &name);

    bool inLib() const;
    void setInLib(bool inLib);

    const QString &driver() const;
    void setDriver(const QString &driver);

    const QString &categ() const;
    void setCateg(const QString &categ);

    qint32 addrAbs() const;
    void setAddrAbs(const qint32 &value);

    quint8 sizeAddrRel() const;
    void setSizeAddrRel(const quint8 &value);

    quint8 masterCount() const;
    void setMasterCount(const quint8 &value);

    int xPos() const;
    void setXPos(int value);

    int yPos() const;
    void setYPos(int value);

    const QString &description() const;
    void setDescription(const QString &description);

    virtual QString type() const;

    QList<File *> &files();
    const QList<File *> &files() const;
    void addFile(File *file);
    void addFiles(const QList<File *> &files);
    File *getFile(const QString &name) const;

    QList<Param *> &params();
    const QList<Param *> &params() const;
    void addParam(Param *param);
    void addParams(const QList<Param *> &params);
    Param *getParam(const QString &name) const;

    QList<BlockProperty *> &properties();
    const QList<BlockProperty *> &properties() const;
    void addProperty(BlockProperty *property);
    void addProperties(const QList<BlockProperty *> &properties);
    BlockProperty *getBlockProperty(const QString &name) const;

    QList<Flow *> &flows();
    const QList<Flow *> &flows() const;
    void addFlow(Flow *flow);
    void addFlows(const QList<Flow *> &flows);
    Flow *getFlow(const QString &name) const;

    QList<Clock *> &clocks();
    const QList<Clock *> &clocks() const;
    void addClock(Clock *clock);
    void addClocks(const QList<Clock *> &clocks);
    Clock *getClock(const QString &name) const;

    QList<Port *> &ports();
    const QList<Port *> &ports() const;
    void addPort(Port *port);
    void addPorts(const QList<Port *> &ports);
    Port *getPort(const QString &name) const;

    QList<Pin *> &pins();
    const QList<Pin *> &pins() const;
    void addPin(Pin *pin);
    void addPins(const QList<Pin *> &pins);
    Pin *getPin(const QString &name) const;

    QList<Reset *> &resets();
    const QList<Reset *> &resets() const;
    void addReset(Reset *reset);
    void addResets(const QList<Reset *> &resets);
    Reset *getReset(const QString &name) const;

public:
    static Block *fromNodeGenerated(const QDomElement &domElement, Block *block=NULL);
    static QList<Block *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    bool _inLib;
    QString _driver;
    QString _categ;
    qint32 _addrAbs;
    quint8 _sizeAddrRel;
    quint8 _masterCount;
    int _xPos;
    int _yPos;
    QString _description;

    QList<File *> _files;
    QList<Param *> _params;
    QList<BlockProperty *> _properties;
    QList<Flow *> _flows;
    QList<Clock *> _clocks;
    QList<Port *> _ports;
    QList<Pin *> _pins;
    QList<Reset *> _resets;
};

#endif // BLOCK_H
