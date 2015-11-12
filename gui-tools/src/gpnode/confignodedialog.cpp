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

    foreach (BoardLib *board, _project->lib()->boards())
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

    BoardLib *board = _project->lib()->board(arg1);
    if(!board) return;

    QMapIterator<QString, IOLibGroup> i(board->iosGroups());
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
