#ifndef MODEL_IOCOM_H
#define MODEL_IOCOM_H

#include "gpstudio_lib_common.h"

#include "model_io.h"

#include "model_comconnect.h"

class GPSTUDIO_LIB_EXPORT ModelIOCom : public ModelIO
{
public:
    ModelIOCom();
    ~ModelIOCom();

    QString type() const;

    QString driverIO() const;
    void setDriverIO(const QString &driverIO);

    void addComConnect(ModelComConnect *comConnect);
    void addComConnects(const QList<ModelComConnect *> &comConnects);
    QList<ModelComConnect *> comConnects();
    const QList<ModelComConnect *> comConnects() const;

public:
    static ModelIO *fromNodeGenerated(const QDomElement &domElement, ModelIOCom *ioCom=NULL);

protected:
    QString _driverIO;

    QList<ModelComConnect *> _comConnects;
};

#endif // MODEL_IOCOM_H
