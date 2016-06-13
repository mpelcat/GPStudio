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
#include <QDialogButtonBox>
#include <QSpacerItem>

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
    BoardLib *board = Lib::getLib().board(boardName);
    if(!board)
        return;

    QWidget *widget = new QWidget();
    widget->setSizePolicy(QSizePolicy::Maximum, QSizePolicy::Maximum);

    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    QMapIterator<QString, IOBoardLibGroup> i(board->iosGroups());
    while (i.hasNext())
    {
        i.next();

        QGroupBox *group = new QGroupBox(i.value().name());

        QLayout *groupLayout = new QVBoxLayout();
        groupLayout->setContentsMargins(0,0,0,0);

        foreach(QString ioName, i.value().ios())
        {
            IOBoardLib *io = board->io(ioName);
            if(io)
            {
                if(io->isOptional())
                {
                    QCheckBox *checkBox = new QCheckBox(io->name());
                    groupLayout->addWidget(checkBox);
                }
                else
                {
                    QRadioButton *checkBox = new QRadioButton(io->name());
                    groupLayout->addWidget(checkBox);
                }
            }
        }

        group->setLayout(groupLayout);
        layout->addWidget(group);
    }

    widget->setLayout(layout);
    _iosWidget->setWidget(widget);
}

void ConfigNodeDialog::setupWidgets()
{
    QVBoxLayout *layout = new QVBoxLayout();

    _boardComboBox = new QComboBox();
    connect(_boardComboBox, SIGNAL(currentIndexChanged(QString)), this, SLOT(selectBoard(QString)));
    layout->addWidget(_boardComboBox);

    _iosWidget = new QScrollArea();
    layout->addWidget(_iosWidget);

    QDialogButtonBox *buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok | QDialogButtonBox::Cancel);
    layout->addWidget(buttonBox);

    connect(buttonBox, SIGNAL(accepted()), this, SLOT(accept()));
    connect(buttonBox, SIGNAL(rejected()), this, SLOT(reject()));

    setLayout(layout);

    setGeometry(100, 100, 300, 400);
}
