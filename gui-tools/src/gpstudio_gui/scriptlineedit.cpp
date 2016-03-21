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

#include "scriptlineedit.h"

#include <QKeyEvent>

#include "scriptengine.h"

#include <camera/camera.h>

ScriptLineEdit::ScriptLineEdit(QWidget *parent) :
    QLineEdit(parent)
{
}

ScriptLineEdit::~ScriptLineEdit()
{
}

void ScriptLineEdit::keyPressEvent(QKeyEvent *event)
{
    if(event->key() == Qt::Key_Up) emit up();
    if(event->key() == Qt::Key_Down) emit down();

    QStringList list;

    foreach (Property *property, ScriptEngine::getEngine().rootProperty()->subProperties())
    {
        list << property->name();
    }

    _completer = new QCompleter(list);
    setCompleter(_completer);

    QLineEdit::keyPressEvent(event);
}
