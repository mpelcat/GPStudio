/****************************************************************************
** Copyright (C) 2014 Dream IP
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

#ifndef PROPERTY_H
#define PROPERTY_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>

#include "propertyenum.h"

class Camera;

class ModelProperty;
class ModelFlow;
class ModelBlock;

class GPSTUDIO_LIB_EXPORT Property : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(Property)
public:
    Property(QString name=QString());
    virtual ~Property();

    const QString &name() const;
    void setName(const QString &name);
    Q_PROPERTY(QString name READ name WRITE setName SCRIPTABLE true)

    const QString &caption() const;
    void setCaption(const QString &caption);

    const QVariant &value() const;
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged SCRIPTABLE true)

    uint bits() const;
    Q_PROPERTY(uint bits READ bits WRITE setBits NOTIFY bitsChanged SCRIPTABLE true)

    const QVariant &min() const;
    const QVariant &max() const;
    const QVariant &step() const;

    const QMap<QString, PropertyEnum *> &enumsMap() const;
    const QList<PropertyEnum *> enums() const;

    enum Type {Group, Int, SInt, Bool, Enum, Matrix, FlowType, BlockType, String, FlowDataType};
    Type type() const;

    const QString &propertymap() const;
    const QString &onchange() const;

    Property &operator[](const QString &name);
    const QList<Property* > &subProperties() const;
    const QMap<QString, Property* > &subPropertiesMap() const;
    void addSubProperty(Property *property);
    void removeAllSubProperties();

    Property *parent() const;

    int row() const;
    void setRow(int row);

    Property *path(const QString &path);

    QStringList dependsProperties() const;

signals:
    void valueChanged(QVariant value);
    void bitsChanged(uint value);

public slots:
    void setValue(bool value);
    void setValue(int value);
    void setValue(const QVariant &value);

    void setBits(const uint bits);

    void eval();

public:
    static Property *fromModelProperty(const ModelProperty *modelProperty);
    static Property *fromModelFlow(const ModelFlow *modelFlow);
    static Property *fromModelBlock(const ModelBlock *modelBlock);

protected:

    void setMin(const QVariant &min);
    void setMax(const QVariant &max);
    void setStep(const QVariant &step);

    void setType(const Type &type);
    void setPropertymap(const QString &propertymap);
    void setOnchange(const QString &onchange);

    void setParent(Property *parent);

protected:
    QString _name;
    QString _caption;
    QVariant _value;
    uint _bits;
    Type _type;

    // TODO move these attributes to sub-properties
    QVariant _min;
    QVariant _max;
    QVariant _step;

    QString _propertyMap;
    QString _onchange;

    int _row;
    Property *_parent;

    QMap<QString, PropertyEnum* > _enumsMap;

    QMap<QString, Property* > _subPropertiesMap;
    QList<Property*> _subProperties;
};

#endif // PROPERTY_H
