#include "connectnodedialog.h"
#include "ui_connectnodedialog.h"

ConnectNodeDialog::ConnectNodeDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ConnectNodeDialog)
{
    ui->setupUi(this);
    connect(ui->camTreeView, SIGNAL(cameraSelected(CameraInfo)), this, SLOT(selectCam(CameraInfo)));
    connect(&_refreshTimer, SIGNAL(timeout()), ui->camTreeView, SLOT(refreshCams()));
    _refreshTimer.start(500);
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
    done(QDialog::Accepted);
}

CameraInfo ConnectNodeDialog::cameraInfo() const
{
    return _cameraInfo;
}

void ConnectNodeDialog::on_buttonBox_accepted()
{
    _cameraInfo = ui->camTreeView->camInfoSelected();
}
