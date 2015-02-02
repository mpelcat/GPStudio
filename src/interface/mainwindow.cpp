#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QDebug>
#include <QImage>
#include <QFileDialog>

#include "../../../std_project/params.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    _cam = NULL;//new Camera("USB");
    connect(ui->camTreeView, SIGNAL(cameraSelected(CameraInfo)), this, SLOT(cameraChanged(CameraInfo)));
    //ui->in->setReadOnly(false);
    const QVector<CameraInfo> &cams = Camera::avaibleCams();
    //if(!cams.empty()) cameraChanged(cams.first());

    connect(ui->flowEnableBox, SIGNAL(toggled(bool)), this, SLOT(usbEnable()));

    ui->caphinComboBox->addItem("MT9",(int)FI_CAPH_TOPLEVEL_IN_MT9_OUT);
    ui->caphinComboBox->addItem("USB",(int)FI_CAPH_TOPLEVEL_IN_USB_OUT0);

    ui->usbinComboBox->addItem("MT9",(int)FI_USB_IN0_MT9_OUT);
    ui->usbinComboBox->addItem("USB",(int)FI_USB_IN0_USB_OUT0);
    ui->usbinComboBox->addItem("CAPH",(int)FI_USB_IN0_CAPH_TOPLEVEL_OUT);

    _sizeViewer = QSize(320,240);
}

MainWindow::~MainWindow()
{
    delete ui;
    delete _cam;
}

void printBuff(const QByteArray &array)
{
    QString out;
    for(int i=0; i<array.size(); i+=2)
    {
        unsigned int value = (unsigned char)array[i]+(unsigned char)array[i+1]*256;
        out.append(QString::number(value,16));
        out.append(" ");
    }
    qDebug()<<out;
}

void MainWindow::on_sendButton_clicked()
{
    if(!_cam) return;

    QString filename = ui->fileImageEdit->text();
    QImage image = QImage(filename).scaled(ui->widthSpinBox->value(),ui->heightSpinBox->value());

    _size = image.size();
    _cam->outputFlow()[1]->send(image);

    _time = QDateTime::currentDateTime();
    //ui->in->setData(FlowData(image).data());
}

void MainWindow::on_refreshButton_clicked()
{
    ui->camTreeView->refreshCams();
}

void MainWindow::on_statusButton_clicked()
{
    if(!_cam) return;
    _cam->askStatus();
}

void MainWindow::dataReceive(QByteArray data)
{
    //ui->out->setData(data);
    //qDebug() << data.mid(0,2).toHex();
    unsigned short numpacket = ((unsigned short)((unsigned char)data[2])*256)+(unsigned char)data[3];
    unsigned char flagFlow = data[1];
    if(flagFlow==0xBA)
    qDebug()<<numpacket << data.mid(1,1).toHex() <<  data.size() << "status"<<_cam->cameraIO()->status();
    //qDebug()<<((unsigned short)((unsigned char)data[2])*256)+(unsigned char)data[3] << data.mid(1,10).toHex();
    //qDebug() << QDateTime::currentDateTime().msecsTo(_time);
}

void MainWindow::flowReceive(int flow)
{
    //qDebug()<<"flow rec in" << -QDateTime::currentDateTime().msecsTo(_time) << "ms";
    _time = QDateTime::currentDateTime();
    if(flow==0)
    {
        const QImage &image = _cam->inputFlow()[flow]->getData().toImage(_sizeViewer, 16);
        ui->imageView->showImage(image);
        image.save("image/" + QDateTime::currentDateTime().toString() + ".jpg");
    }
    else
    {
        qDebug()<<"toto size:"<<_size;
        ui->imageView->showImage(_cam->inputFlow()[flow]->getData().toImage(_size, 16));
    }

    _cam->inputFlow()[flow]->getData();
}

void MainWindow::cameraChanged(CameraInfo info)
{
    delete _cam;
    _cam = new Camera(info);
    connect(_cam, SIGNAL(packetArrived(QByteArray)), this, SLOT(dataReceive(QByteArray)));

    connect(_cam, SIGNAL(flowReadyToRead(int)), this, SLOT(flowReceive(int)));
    if(_cam->isConnected())
    {
        ui->sendButton->setEnabled(true);
        ui->statusButton->setEnabled(true);
    }
}

bool MainWindow::event(QEvent *event)
{
    if(event->type()==QEvent::Close) _cam->stop();
    return QMainWindow::event(event);
}

void MainWindow::on_thresholdSlider_valueChanged(int value)
{
    if(!_cam) return;
    _cam->writeParam(CAPH_TOPLEVEL_THRESHOLD, value);
}

void MainWindow::usbEnable()
{
    if(!_cam) return;
    //_cam->writeParam(MT9_FLOWLENGHT, 321*241);
    _cam->writeParam(USB_ENABLE, (ui->flowEnableBox->isChecked()));
    //_cam->writeParam(MT9_ENABLE, (ui->flowEnableBox->isChecked()));
}

void MainWindow::on_mt9EnableBox_clicked()
{
    if(!_cam) return;
    _cam->writeParam(MT9_ENABLE, (ui->mt9EnableBox->isChecked()));
}

void MainWindow::on_imageChooseButton_clicked()
{
    QString filename = QFileDialog::getOpenFileName(this,"","/home/luca/Seafile/DreamCam/Software/interface_dream_cam");
    ui->fileImageEdit->setText(filename);
    const QImage &image = QImage(filename);
    ui->heightSpinBox->setValue(image.size().height());
    ui->widthSpinBox->setValue(image.size().width());
}

void MainWindow::on_caphinComboBox_currentIndexChanged(int index)
{
    int val=ui->caphinComboBox->itemData(index, Qt::UserRole).toInt();
    if(!_cam) return;
     _cam->writeParam(FI_CAPH_TOPLEVEL_IN,val);

}

void MainWindow::on_usbinComboBox_currentIndexChanged(int index)
{
    int val=ui->usbinComboBox->itemData(index,Qt::UserRole).toInt();
    if(!_cam) return;
    _cam->writeParam(FI_USB_IN0,val);
}

void MainWindow::on_sendMT9Config_clicked()
{
    send_mt9_config();
}

void MainWindow::on_left_mt9_clicked()
{
    if(ui->xstartMT9LineEdit->value()>=100)
    {
        ui->xstartMT9LineEdit->setValue(ui->xstartMT9LineEdit->value()-100);
        send_mt9_config();
    }
}

void MainWindow::on_right_mt9_clicked()
{
    if(ui->xstartMT9LineEdit->value()<1280-100)
    {
        ui->xstartMT9LineEdit->setValue(ui->xstartMT9LineEdit->value()+100);
        send_mt9_config();
    }
}

void MainWindow::on_down_mt9_clicked()
{
    if(ui->ystartMT9SpinBox->value()<960-100)
    {
        ui->ystartMT9SpinBox->setValue(ui->ystartMT9SpinBox->value()+100);
        send_mt9_config();
    }
}

void MainWindow::on_up_mt9_clicked()
{
    if(ui->ystartMT9SpinBox->value()>=100)
    {
        ui->ystartMT9SpinBox->setValue(ui->ystartMT9SpinBox->value()-100);
        send_mt9_config();
    }
}

void MainWindow::send_mt9_config()
{
    if(!_cam) return;
    int xstart = ui->xstartMT9LineEdit->value();
    int ystart = ui->ystartMT9SpinBox->value();
    int width = ui->widthMT9SpinBox->value();
    int height = ui->heightMT9SpinBox->value();
    _cam->writeParam(MT9_FLOWLENGHT, (width)*(height));
    _cam->writeParam(MT9_XSTART, xstart);
    _cam->writeParam(MT9_YSTART, ystart);
    _cam->writeParam(MT9_XEND, xstart+width-1);
    _cam->writeParam(MT9_YEND, ystart+height-1);
    _cam->writeParam(MT9_AUTOEXP, ui->aemt9_box->isChecked());
    _cam->writeParam(MT9_INTEGTIME, ui->integtimeMT9->value());
    _sizeViewer = QSize(width, height);
}

void MainWindow::on_integtimeMT9_valueChanged(int value)
{
    send_mt9_config();
}

void MainWindow::on_aemt9_box_toggled(bool checked)
{
    send_mt9_config();
}
