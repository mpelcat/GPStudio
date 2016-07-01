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
    _process = NULL;

    emit actionAvailable(true);
    emit stopAvailable(false);
}

void CompileLogWidget::appendLog(const QString &log)
{
    _textWidget->append(log);
}

void CompileLogWidget::launch(const QString &cmd, const QStringList &args)
{
    _process = new QProcess(this);
    connect(_process, SIGNAL(readyReadStandardError()), this, SLOT(readProcess()));
    connect(_process, SIGNAL(readyReadStandardOutput()), this, SLOT(readProcess()));
    connect(_process, SIGNAL(finished(int,QProcess::ExitStatus)), this, SLOT(exitProcess()));
    connect(_process, SIGNAL(error(QProcess::ProcessError)), this, SLOT(errorProcess()));

    emit actionAvailable(false);
    emit stopAvailable(true);

    // _textWidget->clear();
    _startProcessDate = QDateTime::currentDateTime();
    _process->start(cmd, args);
}

void CompileLogWidget::readProcess()
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

        html.append("<p><span style=\"color: "+colorHTML+"\">"+colorReg.cap(2)+"</span></p>");

        pos += colorReg.matchedLength();
    }

    dataRead = _process->readAllStandardError();
    html.append("<p><span style=\"color: red\">"+dataRead+"</span></p>");

    appendLog(html);
}

void CompileLogWidget::launchClear()
{
    QString program = "make";
    QStringList arguments;
    arguments << "clear";

    launch(program, arguments);
}

void CompileLogWidget::launchGenerate()
{
    QString program = "gpnode";
    QStringList arguments;
    arguments << "generate" << "-o" << "build";

    launch(program, arguments);
}

void CompileLogWidget::launchCompile()
{
    QString program = "make";
    QStringList arguments;
    arguments << "compile";

    launch(program, arguments);
}

void CompileLogWidget::launchSend()
{
    QString program = "make";
    QStringList arguments;
    arguments << "send";

    launch(program, arguments);
}

void CompileLogWidget::launchView()
{
    QString program = "make";
    QStringList arguments;
    arguments << "view";

    launch(program, arguments);
}

void CompileLogWidget::stopAll()
{
    if(_process)
        _process->terminate();
}

void CompileLogWidget::exitProcess()
{
    appendLog(QString("process '%1' exit with code %2 at %3. elapsed time: %4s")
              .arg(_process->program() + " " + _process->arguments().join(" "))
              .arg(_process->exitCode())
              .arg(QDateTime::currentDateTime().toString())
              .arg((QDateTime::currentMSecsSinceEpoch() - _startProcessDate.toMSecsSinceEpoch())/1000));

    emit actionAvailable(true);
    emit stopAvailable(false);

    _process->deleteLater();
    _process = NULL;
}

void CompileLogWidget::errorProcess()
{
    appendLog("failed...");
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
