#include "boardlib.h"

#include <QFile>
#include <QDebug>

BoardLib::BoardLib()
{
}
QString BoardLib::name() const
{
    return _name;
}

void BoardLib::setName(const QString &name)
{
    _name = name;
}

QList<IOLib *> &BoardLib::ios()
{
    return _ios;
}

const QList<IOLib *> &BoardLib::ios() const
{
    return _ios;
}

void BoardLib::addIO(IOLib *io)
{
    _ios.append(io);
}

void BoardLib::addIOs(const QList<IOLib *> &ios)
{
    _ios.append(ios);
}

BoardLib *BoardLib::readFromFile(const QString &fileName)
{
    QDomDocument doc;
    QFile file(fileName);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file)) qDebug()<<"Cannot open"<<file.fileName();
        else
        {
            return BoardLib::fromNodeGenerated(doc.documentElement());
        }
        file.close();
    }
    return NULL;
}

BoardLib *BoardLib::fromNodeGenerated(const QDomElement &domElement)
{
    BoardLib *board=new BoardLib();
    board->setName(domElement.attribute("name","no_name"));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="ios") board->addIOs(IOLib::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return board;
}

