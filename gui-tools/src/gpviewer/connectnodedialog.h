#ifndef CONNECTNODEDIALOG_H
#define CONNECTNODEDIALOG_H

#include <QDialog>
#include <QTimer>
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

    void on_buttonBox_accepted();

private:
    Ui::ConnectNodeDialog *ui;

    CameraInfo _cameraInfo;
    QTimer _refreshTimer;
};

#endif // CONNECTNODEDIALOG_H
