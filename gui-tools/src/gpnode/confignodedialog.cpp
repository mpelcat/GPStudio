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
#include "ui_confignodedialog.h"

#include <QDebug>

#include <QCheckBox>
#include <QRadioButton>
#include <QGroupBox>
#include <QLayout>

ConfigNodeDialog::ConfigNodeDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ConfigNodeDialog)
{
    ui->setupUi(this);
}

ConfigNodeDialog::~ConfigNodeDialog()
{
    delete ui;
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
        ui->boardComboBox->addItem(board->name());
    }
}

void ConfigNodeDialog::on_boardComboBox_currentIndexChanged(const QString &arg1)
{
    while(!ui->iosLayout->isEmpty())
    {
        delete ui->iosLayout->itemAt(0)->widget();
    }

    BoardLib *board = Lib::getLib().board(arg1);
    if(!board) return;

    QMapIterator<QString, IOBoardLibGroup> i(board->iosGroups());
    while (i.hasNext())
    {
        i.next();
        QGroupBox *group = new QGroupBox(i.value().name());
        ui->iosLayout->addWidget(group);
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
