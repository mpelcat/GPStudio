#include "processlib.h"

#include <QFile>
#include <QSvgRenderer>
#include <QDebug>
#include <QPainter>

ProcessLib::ProcessLib()
{
}

QString ProcessLib::name() const
{
    return _name;
}

void ProcessLib::setName(const QString &name)
{
    _name = name;
}

QString ProcessLib::description() const
{
    return _description;
}

void ProcessLib::setDescription(const QString &description)
{
    _description = description;
}

QString ProcessLib::categ() const
{
    return _categ;
}

void ProcessLib::setCateg(const QString &categ)
{
    _categ = categ;
}

QString ProcessLib::path() const
{
    return _path;
}

void ProcessLib::setPath(const QString &path)
{
    _path = path;
}

QString ProcessLib::configFile() const
{
    return _configFile;
}

void ProcessLib::setConfigFile(const QString &configFile)
{
    _configFile = configFile;
}

QString ProcessLib::draw() const
{
    return _draw;
}

void ProcessLib::setDraw(const QString &draw)
{
    _draw = draw;
}

QIcon ProcessLib::icon() const
{
    return _icon;
}

void ProcessLib::setIcon(const QIcon &icon)
{
    _icon = icon;
}

ProcessLib *ProcessLib::readFromFile(const QString &fileName)
{
    QDomDocument doc;
    QFile file(fileName);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file)) qDebug()<<"Cannot open"<<file.fileName();
        else
        {
            return ProcessLib::fromDomElement(doc.documentElement());
        }
        file.close();
    }
    return NULL;
}

ProcessLib *ProcessLib::fromDomElement(const QDomElement &domElement)
{
    ProcessLib *processLib=new ProcessLib();
    processLib->setName(domElement.attribute("name","no_name"));
    processLib->setCateg(domElement.attribute("categ",""));
    processLib->setDescription(domElement.attribute("description",""));

    const QDomNodeList &nodesSvg = domElement.elementsByTagName("svg");
    if(nodesSvg.size()>0)
    {
        QString svg;
        QTextStream streamSvg(&svg);
        streamSvg << nodesSvg.at(0);
        processLib->setDraw(svg);
    }

    QSvgRenderer render;
    QPixmap pixIcon(32,32);
    QPainter painter(&pixIcon);
    render.load(processLib->draw().toUtf8());
    render.render(&painter, QRectF(0,0,32,32));
    painter.end();
    processLib->_icon.addPixmap(pixIcon);

    return processLib;
}
