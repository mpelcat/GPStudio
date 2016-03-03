#include "scriptengine.h"

#include <QDebug>

#include "camera/property.h"
#include "camera/camera.h"

ScriptEngine *ScriptEngine::_instance = NULL;

ScriptEngine::ScriptEngine(QObject *parent) : QObject(parent)
{
    _camera = NULL;

    _engine.evaluate("Math.__proto__.log2=function(x){ return this.log(x) / this.log(2); }");
}

ScriptEngine::~ScriptEngine()
{

}

QScriptEngine *ScriptEngine::engine()
{
    return &_engine;
}

void ScriptEngine::addProperty(Property *property)
{
    PropertyClass *prop=new PropertyClass(&_engine, property);
    QScriptValue value = _engine.newObject(prop);
    _engine.globalObject().setProperty(property->name(), value);
}

void ScriptEngine::setCamera(Camera *camera)
{
    _camera = camera;

    foreach (Property *property, camera->paramsBlocks()->subProperties())
    {
        computePropertyMap(property, _camera->paramsBlocks());
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
            Property *prop = paramsProps->path(propPath);
            if(prop) connect(prop, SIGNAL(valueChanged(QVariant)), subProperty, SLOT(eval()));
        }

        computePropertyMap(subProperty, paramsProps);
    }
}
