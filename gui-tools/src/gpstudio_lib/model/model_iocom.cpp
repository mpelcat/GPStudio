#include "model_iocom.h"

#include "model_comconnect.h"

ModelIOCom::ModelIOCom()
{
}

ModelIOCom::~ModelIOCom()
{
    for(int i=0; i<_comConnects.size(); i++) delete _comConnects[i];
}

QString ModelIOCom::type() const
{
    return "iocom";
}

QString ModelIOCom::driverIO() const
{
    return _driverIO;
}

void ModelIOCom::setDriverIO(const QString &driverIO)
{
    _driverIO = driverIO;
}

void ModelIOCom::addComConnect(ModelComConnect *comConnect)
{
    _comConnects.append(comConnect);
}

void ModelIOCom::addComConnects(const QList<ModelComConnect *> &comConnects)
{
    foreach (ModelComConnect *comConnect, comConnects)
    {
        addComConnect(comConnect);
    }
}

QList<ModelComConnect *> ModelIOCom::comConnects()
{
    return _comConnects;
}

const QList<ModelComConnect *> ModelIOCom::comConnects() const
{
    return _comConnects;
}

ModelIO *ModelIOCom::fromNodeGenerated(const QDomElement &domElement, ModelIOCom *ioCom)
{
    if(ioCom==NULL) ioCom = new ModelIOCom();

    ioCom->setDriverIO(domElement.attribute("driverio",""));

    ModelIO::fromNodeGenerated(domElement, ioCom);

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="com_connects") ioCom->addComConnects(ModelComConnect::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return ioCom;
}

