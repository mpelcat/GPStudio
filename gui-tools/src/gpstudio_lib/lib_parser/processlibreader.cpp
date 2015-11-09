#include "processlibreader.h"

#include <QDir>
#include <QDebug>
#include <QDomDocument>

void ProcessLibReader::readFromPath(const QString &path, Lib &lib)
{
    QDir dirPath(path);

    foreach (QFileInfo pathLib, dirPath.entryInfoList(QStringList(), QDir::Dirs | QDir::NoDotAndDotDot))
    {
        QDir dirIP(pathLib.absoluteFilePath());
        foreach (QFileInfo ipInfo, dirIP.entryInfoList(QStringList("*.proc")))
        {
            ProcessLib process;
            readProcessLib(ipInfo.absoluteFilePath(), process);
            //lib.addProcess(process);
        }
    }
}

void ProcessLibReader::readProcessLib(const QString &configFile, ProcessLib &processLib)
{
    QDomDocument doc;
    QFile file(configFile);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file)) qDebug()<<"Cannot open"<<file.fileName();
        else
        {
            QDomElement root=doc.documentElement();
            processLib.setName(root.attribute("name","no_name"));
            processLib.setCateg(root.attribute("categ",""));
            processLib.setDescription(root.attribute("description",""));

            const QDomNodeList &nodesSvg = doc.elementsByTagName("svg");
            if(nodesSvg.size()>0)
            {
                QString svg;
                QTextStream streamSvg(&svg);
                streamSvg << nodesSvg.at(0);
                processLib.setDraw(svg);
            }

            qDebug()<<processLib.name();

            QFileInfo info(configFile);
            processLib.setConfigFile(configFile);
            processLib.setPath(info.absolutePath());

        }
        file.close();
    }
}
