#include "io.h"

#include <QDebug>

IO::IO()
{
}

IO::~IO()
{
}

QString IO::type() const
{
    return "io";
}

IO *IO::fromNodeGenerated(const QDomElement &domElement, IO *io)
{
    if(io==NULL) io = new IO();

    Block::fromNodeGenerated(domElement, io);

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="ports") io->addPorts(Port::listFromNodeGenerated(e));
            if(e.tagName()=="pins") io->addPins(Pin::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return io;
}
