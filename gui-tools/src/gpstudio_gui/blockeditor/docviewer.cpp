#include "docviewer.h"

#include <QLayout>
#include <QDebug>
#include <QFileInfo>
#include <QKeyEvent>
#include <QPlainTextEdit>

DocViewer::DocViewer(QWidget *parent) : QWidget(parent)
{
}

void DocViewer::loadFileCode(QString file)
{
    QFileInfo info(file);

    if(layout())
    {
        while (layout()->count())
        {
            delete layout()->takeAt(0)->widget();
        }
        delete layout();
    }

    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    if((QStringList()<<"html"<<"htm").contains(info.suffix()))
    {
        QPlainTextEdit *htmlViewer = new QPlainTextEdit();
        layout->addWidget(htmlViewer);

        QFile fileIO(file);
        if(fileIO.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            htmlViewer->appendHtml(fileIO.readAll());
            fileIO.close();
        }
    }
    else if((QStringList()<<"txt"<<"").contains(info.suffix()))
    {
        QPlainTextEdit *textViewer = new QPlainTextEdit();
        layout->addWidget(textViewer);

        QFile fileIO(file);
        if(fileIO.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            textViewer->appendPlainText(fileIO.readAll());
            fileIO.close();
        }
    }
    else if((QStringList()<<"pdf").contains(info.suffix()))
    {
        //
    }

    setLayout(layout);
}
