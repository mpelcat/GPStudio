#ifndef CONFIGNODEDIALOG_H
#define CONFIGNODEDIALOG_H

#include <QDialog>

#include "lib_parser/lib.h"

namespace Ui {
class ConfigNodeDialog;
}

class ConfigNodeDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ConfigNodeDialog(QWidget *parent = 0);
    ~ConfigNodeDialog();

    Lib *lib() const;
    void setLib(Lib *lib);

private:
    Ui::ConfigNodeDialog *ui;

    Lib *_lib;
};

#endif // CONFIGNODEDIALOG_H
