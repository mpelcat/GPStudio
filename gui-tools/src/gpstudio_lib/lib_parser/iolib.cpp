#include "iolib.h"

#include <QFile>
#include <QSvgRenderer>
#include <QDebug>
#include <QPainter>

IOLib::IOLib()
{
}

QString IOLib::name() const
{
    return _name;
}

void IOLib::setName(const QString &name)
{
    _name = name;
}

QString IOLib::description() const
{
    return _description;
}

void IOLib::setDescription(const QString &description)
{
    _description = description;
}

QString IOLib::categ() const
{
    return _categ;
}

void IOLib::setCateg(const QString &categ)
{
    _categ = categ;
}

QString IOLib::path() const
{
    return _path;
}

void IOLib::setPath(const QString &path)
{
    _path = path;
}

QString IOLib::configFile() const
{
    return _configFile;
}

void IOLib::setConfigFile(const QString &configFile)
{
    _configFile = configFile;
}

QString IOLib::draw() const
{
    return _draw;
}

void IOLib::setDraw(const QString &draw)
{
    _draw = draw;
}

QIcon IOLib::icon() const
{
    return _icon;
}

void IOLib::setIcon(const QIcon &icon)
{
    _icon = icon;
}

IOLib *IOLib::readFromFile(const QString &fileName)
{
    QDomDocument doc;
    QFile file(fileName);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file)) qDebug()<<"Cannot open"<<file.fileName();
        else
        {
            return IOLib::fromDomElement(doc.documentElement());
        }
        file.close();
    }
    return NULL;
}

IOLib *IOLib::fromDomElement(const QDomElement &domElement)
{
    IOLib *ioLib=new IOLib();
    ioLib->setName(domElement.attribute("driver","no_name"));
    ioLib->setCateg(domElement.attribute("categ",""));
    ioLib->setDescription(domElement.attribute("description",""));

    const QDomNodeList &nodesSvg = domElement.elementsByTagName("svg");
    if(nodesSvg.size()>0)
    {
        QString svg;
        QTextStream streamSvg(&svg);
        streamSvg << nodesSvg.at(0);
        ioLib->setDraw(svg);
    }

    QSvgRenderer render;
    QPixmap pixIcon(32,32);
    QPainter painter(&pixIcon);
    render.load(ioLib->draw().toUtf8());
    render.render(&painter, QRectF(0,0,32,32));
    painter.end();
    ioLib->_icon.addPixmap(pixIcon);

    return ioLib;
}
