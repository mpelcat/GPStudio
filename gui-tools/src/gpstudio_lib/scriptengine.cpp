#include "scriptengine.h"

#include <QDebug>

#include "camera/property.h"
#include "camera/camera.h"

ScriptEngine *ScriptEngine::_instance = NULL;

ScriptEngine::ScriptEngine(QObject *parent) : QObject(parent)
{
    _rootProperty = NULL;

    _engine.evaluate("Math.__proto__.log2=function(x){ return this.log(x) / this.log(2); }");
}

ScriptEngine::~ScriptEngine()
{
}

QScriptEngine *ScriptEngine::engine()
{
    return &_engine;
}

const Property *ScriptEngine::path(const QString &path) const
{
    if(_rootProperty) return _rootProperty->path(path);
}

const Property *ScriptEngine::rootProperty() const
{
    return _rootProperty;
}

void ScriptEngine::setRootProperty(Property *rootProperty)
{
    _rootProperty = rootProperty;

    foreach (Property *property, _rootProperty->subProperties())
    {
        computePropertyMap(property, _rootProperty);

        PropertyClass *prop=new PropertyClass(&_engine, property);
        QScriptValue value = _engine.newObject(prop);
        _engine.globalObject().setProperty(property->name(), value);
    }
}

QScriptValue ScriptEngine::eval(const QString &propertyMap)
{
    QString toEval = propertyMap;
    toEval.replace(".in.",".__in.");

    const QScriptValue &result = _engine.evaluate(toEval);
    if(result.isError())
    {
        QString error = result.toString();
        error.replace("__in","in");
        qDebug()<<"Script engine: error evaluating "<<propertyMap<<error;
    }

    return result;
}

QVariant ScriptEngine::evalPropertyMap(const QString &propertyMap)
{
    return eval(propertyMap).toVariant();
}

QStringList ScriptEngine::dependsProperties(const QString &expression)
{
    QRegExp exp("([a-zA-Z_]+[a-zA-Z0-9_]*\\.?)+");
    int pos=0;
    QStringList props;
    while((pos = exp.indexIn(expression, pos)) != -1)
    {
        pos += exp.matchedLength();
        props.append(exp.cap(0));
    }
    props.removeDuplicates();
    return props;
}

void ScriptEngine::computePropertyMap(Property *property, Property *paramsProps)
{
    foreach (Property *subProperty, property->subProperties())
    {
        const QStringList &deps = subProperty->dependsProperties();
        foreach (QString propPath, deps)
        {
            const Property *prop = paramsProps->path(propPath);
            if(prop) connect(prop, SIGNAL(valueChanged(QVariant)), subProperty, SLOT(eval()));
        }

        computePropertyMap(subProperty, paramsProps);
    }
}
