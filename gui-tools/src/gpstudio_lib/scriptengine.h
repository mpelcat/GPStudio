#ifndef SCRIPTENGINE_H
#define SCRIPTENGINE_H

#include "gpstudio_lib_common.h"

#include <QObject>

#include <QScriptEngine>

#include "propertyclass.h"

class GPSTUDIO_LIB_EXPORT ScriptEngine : public QObject
{
    Q_OBJECT
public:
    explicit ScriptEngine(QObject *parent = 0);
    ~ScriptEngine();

    QScriptEngine *engine();

    void addProperty(Property *property);

    uint evalPropertyMap(const QString &propertyMap, const QString &blockContext);

    static QStringList dependsProperties(const QString &expression);
signals:

public slots:

private:
    QScriptEngine _engine;

    QList<Property *> _properties;
};

#endif // SCRIPTENGINE_H
