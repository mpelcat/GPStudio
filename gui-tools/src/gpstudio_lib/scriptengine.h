#ifndef SCRIPTENGINE_H
#define SCRIPTENGINE_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QScriptEngine>

#include "propertyclass.h"
class Camera;

class GPSTUDIO_LIB_EXPORT ScriptEngine : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(ScriptEngine)

private:
    explicit ScriptEngine(QObject *parent = 0);

public:
    ~ScriptEngine();

    QScriptEngine *engine();

    const Property *path(const QString &path) const;
    const Property *rootProperty() const;
    void setRootProperty(Property *rootProperty);

    QScriptValue eval(const QString &propertyMap);
    QVariant evalPropertyMap(const QString &propertyMap);

    static QStringList dependsProperties(const QString &expression);
    static inline ScriptEngine &getEngine() {if(!_instance) _instance = new ScriptEngine(); return *_instance;}

private:
    static void computePropertyMap(Property *property, Property *paramsProps);

private:
    QScriptEngine _engine;
    static ScriptEngine *_instance;

    Property *_rootProperty;
};

#endif // SCRIPTENGINE_H
