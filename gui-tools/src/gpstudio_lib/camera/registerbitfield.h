#ifndef CAMERAREGISTERBITFIELD_H
#define CAMERAREGISTERBITFIELD_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QStringList>
#include <QList>

class ModelParamBitField;
class Camera;
class Register;

class RegisterBitField : public QObject
{
    Q_OBJECT
public:
    RegisterBitField();
    ~RegisterBitField();

    uint mask() const;
    void setMask(const uint &mask);

    uint value() const;
    void setValue(const uint &value);

    QString blockName() const;
    void setBlockName(const QString &blockName);

    QString propertyMap() const;
    void setPropertyMap(const QString &propertyMap);
    QStringList dependsProperties() const;

    Register *parent() const;
    void setParent(Register *parent);

    const QList<uint> &bits() const;

public:
    static RegisterBitField *fromParamBitField(const ModelParamBitField *paramBitField);

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

    Register *_parent;
};

#endif // CAMERAREGISTERBITFIELD_H
