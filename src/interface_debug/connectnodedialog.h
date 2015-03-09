#ifndef CONNECTNODEDIALOG_H
#define CONNECTNODEDIALOG_H

#include <QDialog>
#include "camerainfo.h"

namespace Ui {
class ConnectNodeDialog;
}

class ConnectNodeDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ConnectNodeDialog(QWidget *parent = 0);
    ~ConnectNodeDialog();

    CameraInfo cameraInfo() const;

private slots:
    void on_refreshButton_clicked();
    void selectCam(CameraInfo cameraInfo);

private:
    Ui::ConnectNodeDialog *ui;

    CameraInfo _cameraInfo;
};

#endif // CONNECTNODEDIALOG_H
