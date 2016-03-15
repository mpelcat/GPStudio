#ifndef FLOW_H
#define FLOW_H

#include "gpstudio_lib_common.h"

#include "property.h"

#include <QString>

class ModelFlow;

/**
 * @brief The Flow class is part of the run time model and represent a flow interface in a block.
 */
class GPSTUDIO_LIB_EXPORT Flow
{
public:
    Flow();

    QString name() const;

    enum Type {Input, Output};
    Type type() const;

    Property *assocProperty() const;

    const ModelFlow *modelFlow() const;

protected:
    void setName(const QString &name);
    void setType(const Type &type);

public:
    static Flow *fromModelFlow(const ModelFlow *modelFlow);

protected:
    QString _name;
    Type _type;

    Property *_assocProperty;

    const ModelFlow *_modelFlow;
};

#endif // FLOW_H
