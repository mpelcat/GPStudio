#ifndef CONFIGNODEDIALOG_H
#define CONFIGNODEDIALOG_H

#include <QDialog>

#include "gpnodeproject.h"

namespace Ui {
class ConfigNodeDialog;
}

class ConfigNodeDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ConfigNodeDialog(QWidget *parent = 0);
    ~ConfigNodeDialog();

    GPNodeProject *project() const;
    void setProject(GPNodeProject *project);

private slots:
    void on_boardComboBox_currentIndexChanged(const QString &arg1);

private:
    Ui::ConfigNodeDialog *ui;

    GPNodeProject *_project;
};

#endif // CONFIGNODEDIALOG_H
