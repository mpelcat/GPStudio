#ifndef BLOCK_H
#define BLOCK_H

#include "gpstudio_lib_common.h"

#include <QDomElement>
#include <QString>
#include <QList>

#include "model_file.h"
#include "model_param.h"
#include "model_property.h"
#include "model_flow.h"
#include "model_clock.h"
#include "model_port.h"
#include "model_pin.h"
#include "model_reset.h"

class GPSTUDIO_LIB_EXPORT ModelBlock
{
protected:
    ModelBlock();

public:
    virtual ~ModelBlock();

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

    QList<ModelFile *> &files();
    const QList<ModelFile *> &files() const;
    void addFile(ModelFile *file);
    void addFiles(const QList<ModelFile *> &files);
    ModelFile *getFile(const QString &name) const;

    QList<ModelParam *> &params();
    const QList<ModelParam *> &params() const;
    void addParam(ModelParam *param);
    void addParams(const QList<ModelParam *> &params);
    ModelParam *getParam(const QString &name) const;

    QList<ModelProperty *> &properties();
    const QList<ModelProperty *> &properties() const;
    void addProperty(ModelProperty *property);
    void addProperties(const QList<ModelProperty *> &properties);
    ModelProperty *getBlockProperty(const QString &name) const;

    QList<ModelFlow *> &flows();
    const QList<ModelFlow *> &flows() const;
    void addFlow(ModelFlow *flow);
    void addFlows(const QList<ModelFlow *> &flows);
    ModelFlow *getFlow(const QString &name) const;

    QList<ModelClock *> &clocks();
    const QList<ModelClock *> &clocks() const;
    void addClock(ModelClock *clock);
    void addClocks(const QList<ModelClock *> &clocks);
    ModelClock *getClock(const QString &name) const;

    QList<ModelPort *> &ports();
    const QList<ModelPort *> &ports() const;
    void addPort(ModelPort *port);
    void addPorts(const QList<ModelPort *> &ports);
    ModelPort *getPort(const QString &name) const;

    QList<ModelPin *> &pins();
    const QList<ModelPin *> &pins() const;
    void addPin(ModelPin *pin);
    void addPins(const QList<ModelPin *> &pins);
    ModelPin *getPin(const QString &name) const;

    QList<ModelReset *> &resets();
    const QList<ModelReset *> &resets() const;
    void addReset(ModelReset *reset);
    void addResets(const QList<ModelReset *> &resets);
    ModelReset *getReset(const QString &name) const;

public:
    static ModelBlock *fromNodeGenerated(const QDomElement &domElement, ModelBlock *block=NULL);
    static QList<ModelBlock *> listFromNodeGenerated(const QDomElement &domElement);

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

    QList<ModelFile *> _files;
    QList<ModelParam *> _params;
    QList<ModelProperty *> _properties;
    QList<ModelFlow *> _flows;
    QList<ModelClock *> _clocks;
    QList<ModelPort *> _ports;
    QList<ModelPin *> _pins;
    QList<ModelReset *> _resets;
};

#endif // BLOCK_H
