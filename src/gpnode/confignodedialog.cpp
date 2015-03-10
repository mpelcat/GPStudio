#include "confignodedialog.h"
#include "ui_confignodedialog.h"

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
Lib *ConfigNodeDialog::lib() const
{
    return _lib;
}

void ConfigNodeDialog::setLib(Lib *lib)
{
    _lib = lib;

    foreach (BoardLib *board, _lib->boards())
    {
        ui->boardComboBox->addItem(board->name()+board->ios().first()->name());
    }
}

