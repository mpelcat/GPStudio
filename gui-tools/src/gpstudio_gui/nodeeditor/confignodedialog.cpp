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

#include "confignodedialog.h"

#include "lib_parser/lib.h"

#include <QDebug>

#include <QCheckBox>
#include <QRadioButton>
#include <QGroupBox>
#include <QLayout>

ConfigNodeDialog::ConfigNodeDialog(QWidget *parent) :
    QDialog(parent)
{
    setupWidgets();
}

ConfigNodeDialog::~ConfigNodeDialog()
{
}

GPNodeProject *ConfigNodeDialog::project() const
{
    return _project;
}

void ConfigNodeDialog::setProject(GPNodeProject *project)
{
    _project = project;

    foreach (BoardLib *board, Lib::getLib().boards())
    {
        _boardComboBox->addItem(board->name());
    }
}

void ConfigNodeDialog::selectBoard(const QString &boardName)
{
    while(!_iosLayout->isEmpty())
    {
        delete _iosLayout->itemAt(0)->widget();
    }

    BoardLib *board = Lib::getLib().board(boardName);
    if(!board) return;

    QMapIterator<QString, IOBoardLibGroup> i(board->iosGroups());
    while (i.hasNext())
    {
        i.next();
        QGroupBox *group = new QGroupBox(i.value().name());
        _iosLayout->addWidget(group);
        QLayout *layout = new QVBoxLayout();
        layout->setContentsMargins(0,0,0,0);
        group->setLayout(layout);
        foreach(QString ioName, i.value().ios())
        {
            IOBoardLib *io = board->io(ioName);
            if(io)
            {
                if(io->isOptional())
                {
                    QCheckBox *checkBox = new QCheckBox(io->name());
                    layout->addWidget(checkBox);
                }
                else
                {
                    QRadioButton *checkBox = new QRadioButton(io->name());
                    layout->addWidget(checkBox);
                }
            }
        }
    }
}

void ConfigNodeDialog::setupWidgets()
{
    QLayout *layout = new QVBoxLayout();

    _boardComboBox = new QComboBox();
    connect(_boardComboBox, SIGNAL(currentIndexChanged(QString)), this, SLOT(selectBoard(QString)));
    layout->addWidget(_boardComboBox);

    _iosLayout = new QVBoxLayout();
    layout->addItem(_iosLayout);

    setLayout(layout);

    setGeometry(100, 100, 300, 400);
}
