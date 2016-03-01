#include "model_io.h"

#include <QDebug>

ModelIO::ModelIO()
{
}

ModelIO::~ModelIO()
{
}

QString ModelIO::type() const
{
    return "io";
}

ModelIO *ModelIO::fromNodeGenerated(const QDomElement &domElement, ModelIO *io)
{
    if(io==NULL) io = new ModelIO();

    ModelBlock::fromNodeGenerated(domElement, io);

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="ports") io->addPorts(ModelPort::listFromNodeGenerated(e));
            if(e.tagName()=="pins") io->addPins(ModelPin::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return io;
}
