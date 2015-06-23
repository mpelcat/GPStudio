#include "propertyclass.h"

#include <QDebug>
#include <QScriptString>
#include <QScriptEngine>

//#define __PROP_DEBUG__

PropertyClass::PropertyClass(QScriptEngine * engine, Property *linkedProperty)
    : QScriptClass(engine), _linkedProperty(linkedProperty)
{
#ifdef __PROP_DEBUG__
    qDebug()<<'\t'<<"==== create prop class";
#endif
}

PropertyClass::~PropertyClass()
{
#ifdef __PROP_DEBUG__
    qDebug()<<'\t'<<"del prop class";
#endif
    QMapIterator<QString, PropertyClass*> it(_subPropertiesClasses);
    while (it.hasNext())
    {
        it.next();
        delete it.value();
    }
}

QString PropertyClass::name() const
{
    return "property";
}

QScriptValue::PropertyFlags PropertyClass::propertyFlags(const QScriptValue &object, const QScriptString &name, uint id)
{
    Q_UNUSED(object);
    Q_UNUSED(id);
#ifdef __PROP_DEBUG__
    qDebug()<<_linkedProperty->name()+".propertyFlags"<<name;
#else
    Q_UNUSED(name);
#endif
    return QScriptValue::PropertyGetter | QScriptValue::PropertySetter;
}

QScriptClass::QueryFlags PropertyClass::queryProperty(const QScriptValue & object, const QScriptString & name, QScriptClass::QueryFlags flags, uint * id )
{
    Q_UNUSED(object);
    Q_UNUSED(id);
#ifdef __PROP_DEBUG__
    qDebug()<<_linkedProperty->name()+".querry"<<name<<flags;
#else
    Q_UNUSED(name);
#endif
    return QScriptClass::HandlesReadAccess;
}

QScriptValue PropertyClass::property(const QScriptValue &object, const QScriptString &name, uint id)
{
    Q_UNUSED(id);
#ifdef __PROP_DEBUG__
    qDebug()<<_linkedProperty->name()+".get"<<name.toString()<<object.toVariant();
#else
    Q_UNUSED(object);
#endif

    if(name.toString()=="toString")
    {
        return engine()->newVariant(object, _linkedProperty->value().toString());
        //return QScriptValue(_linkedProperty->name()+": "+_linkedProperty->value().toString());
    }
    if(name.toString()=="value" || name.toString()=="valueOf")
    {
        switch (_linkedProperty->type())
        {
        case Property::Int:
        case Property::SInt:
            return QScriptValue(_linkedProperty->value().toInt());
        case Property::Bool:
            return QScriptValue(_linkedProperty->value().toBool());
        default:
            return QScriptValue(_linkedProperty->value().toInt());
        }
    }
    if(name.toString()=="bits")
    {
        return QScriptValue(_linkedProperty->bits());
    }
    if(_subPropertiesClasses.contains(name.toString()))
    {
        PropertyClass *prop=_subPropertiesClasses[name.toString()];
        return engine()->newObject(prop);
    }
    else
    {
        if(_linkedProperty->subProperties().propertiesMap().contains(name.toString()))
        {
            PropertyClass *prop=new PropertyClass(engine(), &(*_linkedProperty)[name.toString()]);
            _subPropertiesClasses.insert(name.toString(), prop);
            return engine()->newObject(prop);
        }
    }

    return QScriptValue();
}

void PropertyClass::setProperty(QScriptValue &object, const QScriptString &name, uint id, const QScriptValue &value)
{
    Q_UNUSED(id);
    Q_UNUSED(object);
#ifdef __PROP_DEBUG__
    qDebug()<<_linkedProperty->name()+".set"<<name<<value.toVariant();
#endif
    if(name.toString()=="value")
    {
        _linkedProperty->setValue(value.toVariant());
    }
}
