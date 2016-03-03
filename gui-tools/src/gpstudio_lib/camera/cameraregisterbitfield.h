#ifndef CAMERAREGISTERBITFIELD_H
#define CAMERAREGISTERBITFIELD_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QStringList>
#include <QList>

class ModelParamBitField;
class Camera;
class CameraRegister;

class CameraRegisterBitField : public QObject
{
    Q_OBJECT
public:
    CameraRegisterBitField();
    ~CameraRegisterBitField();

    uint mask() const;
    void setMask(const uint &mask);

    uint value() const;
    void setValue(const uint &value);

    QString blockName() const;
    void setBlockName(const QString &blockName);

    QString propertyMap() const;
    void setPropertyMap(const QString &propertyMap);
    QStringList dependsProperties() const;

    CameraRegister *parent() const;
    void setParent(CameraRegister *parent);

    const QList<uint> &bits() const;

public:
    static CameraRegisterBitField *fromParamBitField(const ModelParamBitField *paramBitField);

signals:
    void bitfieldChange(uint mask, uint value);

public slots:
    void eval();

private:
    uint _mask;
    uint _value;
    QString _blockName;
    QString _propertyMap;

    QList<uint> _bits;

    CameraRegister *_parent;
};

#endif // CAMERAREGISTERBITFIELD_H
