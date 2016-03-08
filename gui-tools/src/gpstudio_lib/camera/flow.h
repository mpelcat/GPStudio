#ifndef FLOW_H
#define FLOW_H

#include "gpstudio_lib_common.h"

#include "property.h"

#include <QString>

class ModelFlow;

class GPSTUDIO_LIB_EXPORT Flow
{
public:
    Flow();

    QString name() const;

    enum Type {Input, Output};
    Type type() const;

    Property *assocProperty() const;

protected:
    void setName(const QString &name);
    void setType(const Type &type);

public:
    static Flow *fromModelFlow(const ModelFlow *modelFlow);

protected:
    QString _name;
    Type _type;

    Property *_assocProperty;
};

#endif // FLOW_H
