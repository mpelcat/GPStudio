#include "connectnodedialog.h"
#include "ui_connectnodedialog.h"

ConnectNodeDialog::ConnectNodeDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ConnectNodeDialog)
{
    ui->setupUi(this);
    connect(ui->camTreeView, SIGNAL(cameraSelected(CameraInfo)), this, SLOT(selectCam(CameraInfo)));
}

ConnectNodeDialog::~ConnectNodeDialog()
{
    delete ui;
}

void ConnectNodeDialog::on_refreshButton_clicked()
{
    ui->camTreeView->refreshCams();
}

void ConnectNodeDialog::selectCam(CameraInfo cameraInfo)
{
    _cameraInfo = cameraInfo;
}

CameraInfo ConnectNodeDialog::cameraInfo() const
{
    return _cameraInfo;
}
