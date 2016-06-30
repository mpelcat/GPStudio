/****************************************************************************
** Copyright (C) 2016 Dream IP
**
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#include "compilelogwidget.h"

#include <QLayout>
#include <QDebug>

CompileLogWidget::CompileLogWidget(QWidget *parent) : QWidget(parent)
{
    setupWidgets();
}

void CompileLogWidget::appendLog()
{
    QRegExp colorReg("\\x001b\\[([0-9]+)m([^\r\n\\x001b]*)");

    QByteArray dataRead = _process->readAllStandardOutput();

    int pos = 0;
    QString html;
    while ((pos = colorReg.indexIn(dataRead, pos)) != -1)
    {
        QString colorCode = colorReg.cap(1);
        QString colorHTML = "black";

        if(colorCode == "33")
            colorHTML = "orange";
        if(colorCode == "31")
            colorHTML = "red";
        if(colorCode == "32")
            colorHTML = "green";

        //_textWidget->appendPlainText("> ");
        html.append("<p><span style=\"color: "+colorHTML+"\">"+colorReg.cap(2)+"</span></p>");
        //_textWidget->appendPlainText("");

        pos += colorReg.matchedLength();
    }
    _textWidget->append(html);
    //qDebug()<<_textWidget->toHtml();
}

void CompileLogWidget::launchGenerate()
{
    QString program = "gpnode";
    QStringList arguments;
    arguments << "generate" << "-o" << "build";

    _process = new QProcess(this);
    connect(_process, SIGNAL(readyReadStandardError()), this, SLOT(appendLog()));
    connect(_process, SIGNAL(readyReadStandardOutput()), this, SLOT(appendLog()));

    // _textWidget->clear();
    _process->start(program, arguments);
}

void CompileLogWidget::setupWidgets()
{
    if(layout())
        layout()->deleteLater();

    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    _textWidget = new QTextEdit();
    _textWidget->setReadOnly(true);
    _textWidget->document()->setDefaultStyleSheet("p{margin: 0;}");
    layout->addWidget(_textWidget);

    setLayout(layout);
}
