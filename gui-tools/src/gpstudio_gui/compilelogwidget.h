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

#ifndef COMPILELOGWIDGET_H
#define COMPILELOGWIDGET_H

#include "gpstudio_gui_common.h"

#include <QWidget>
#include <QTextEdit>
#include <QProcess>

class GPSTUDIO_GUI_EXPORT CompileLogWidget : public QWidget
{
    Q_OBJECT
public:
    explicit CompileLogWidget(QWidget *parent = 0);

signals:
    void stopRequest();

public slots:
    void appendLog();

    void launchGenerate();

private:
    void setupWidgets();

    QTextEdit *_textWidget;

    QProcess *_process;
};

#endif // COMPILELOGWIDGET_H
