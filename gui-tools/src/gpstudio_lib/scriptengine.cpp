#include "scriptengine.h"

#include <QDebug>

#include "property.h"

ScriptEngine::ScriptEngine(QObject *parent) : QObject(parent)
{

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
    property->setEngine(this);
    QScriptValue value = _engine.newObject(prop);
    _engine.globalObject().setProperty(property->name(), value);
}

uint ScriptEngine::evalPropertyMap(const QString &propertyMap, const QString &blockContext)
{
    QScriptValue global;
    if(!blockContext.isEmpty())
    {
        global = _engine.globalObject();
        _engine.currentContext()->setThisObject(_engine.globalObject().property(blockContext));
    }

    const QScriptValue &result = _engine.evaluate(propertyMap);
    if(result.isError()) qDebug()<<"Script engine: error evaluating "<<propertyMap<<result.toString();

    if(!blockContext.isEmpty()) _engine.setGlobalObject(global);

    return result.toUInt32();
}

QStringList ScriptEngine::dependsProperties(const QString &expression)
{
    QRegExp exp("([a-zA-Z0-9_]+\\.?)+");
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
