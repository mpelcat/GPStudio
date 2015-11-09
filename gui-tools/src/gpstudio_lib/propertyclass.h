#ifndef PROPERTYCLASS_H
#define PROPERTYCLASS_H

#include "gpstudio_lib_common.h"

#include <QScriptClass>
#include <QMap>

class Property;

class GPSTUDIO_LIB_EXPORT PropertyClass: public QObject, public QScriptClass
{
public:
    PropertyClass(QScriptEngine *engine, Property *linkedProperty);
    ~PropertyClass();

    virtual QString name() const;

    virtual QScriptValue::PropertyFlags propertyFlags ( const QScriptValue & object, const QScriptString & name, uint id );
    virtual QScriptClass::QueryFlags queryProperty ( const QScriptValue & object, const QScriptString & name, QScriptClass::QueryFlags flags, uint * id );
    virtual QScriptValue property(const QScriptValue &object, const QScriptString &name, uint id);
    virtual void setProperty(QScriptValue &object, const QScriptString &name, uint id, const QScriptValue &value);

private:
    Property *_linkedProperty;
    QMap<QString, PropertyClass*> _subPropertiesClasses;

    QScriptValue _proto;
};

#endif // PROPERTYCLASS_H
