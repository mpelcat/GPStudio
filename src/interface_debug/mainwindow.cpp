#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QDebug>
#include <QImage>
#include <QFileDialog>
#include <QFile>

#include "property.h"
#include "propertywidgets/propertywidgets.h"
#include "connectnodedialog.h"

#include "cameracom.h"
#include "flowcom.h"
#include "flowdata.h"

MainWindow::MainWindow(QStringList args) :
    QMainWindow(0),
    ui(new Ui::MainWindow)
{
    _cam = NULL;

    ui->setupUi(this);
    createToolBarAndMenu();

    if(QFile::exists("../../../std_project/node_generated.xml")) openNodeGeneratedFile("../../../std_project/node_generated.xml");
    else
    {
        if(args.size()>1)
        {
            if(QFile::exists(args[1])) openNodeGeneratedFile(args[1]);
        }
    }
}

MainWindow::~MainWindow()
{
    delete ui;
    if(_cam) delete _cam;
}

bool MainWindow::event(QEvent *event)
{
    if(event->type()==QEvent::Close)
    {
        if(_cam)
        {
            if(_cam->com())
            {
                 _cam->com()->stop();
            }
        }
    }
    return QMainWindow::event(event);
}

void MainWindow::openNode()
{
    QString file = QFileDialog::getOpenFileName(this, "Open node", "", "*.xml");

    if(!file.isEmpty()) openNodeGeneratedFile(file);
}

void MainWindow::createToolBarAndMenu()
{
    // ============= File =============
    QMenu *nodeMenu = ui->menuBar->addMenu("&Node");

    QAction *openDocAction = new QAction("&Open",this);
    openDocAction->setIcon(QIcon(":/icons/img/open.png"));
    openDocAction->setShortcut(QKeySequence::Open);
    ui->mainToolBar->addAction(openDocAction);
    nodeMenu->addAction(openDocAction);
    connect(openDocAction, SIGNAL(triggered()), this, SLOT(openNode()));

    QAction *connectAction = new QAction("&Connect node",this);
    nodeMenu->addAction(connectAction);
    connect(connectAction, SIGNAL(triggered()), this, SLOT(connectCam()));
}

void MainWindow::openNodeGeneratedFile(const QString fileName)
{
    if(_cam) delete _cam;

    _cam = new Camera(fileName);
    ui->scriptWidget->setEngine(_cam->engine());

    foreach (Property *property, _cam->paramsBlocks()->subProperties().properties())
    {
        if(property->type()==Property::Group && property->subProperties().properties().count()>0)
        {
            PropertyWidget *propertyWidget = PropertyWidget::getWidgetFromProperty(property);
            ui->paramsLayout->addWidget(propertyWidget);
        }
    }

    connect(_cam, SIGNAL(registerDataChanged()), this, SLOT(setBiSpace()));

    connectCam();
}

void MainWindow::connectCam()
{
    ConnectNodeDialog connectNodeDialog(this);
    connectNodeDialog.exec();
    _cam->connectCam(connectNodeDialog.cameraInfo());

    if(_cam->isConnected())
    {
        connect(_cam->com(), SIGNAL(flowReadyToRead(int)), this, SLOT(viewFlow(int)));
    }
}

void MainWindow::viewFlow(int flow)
{
    if(flow==0)
    {
        int w = (*_cam->paramsBlocks())["mt9"]["roi1"]["w"].value().toInt();
        int h = (*_cam->paramsBlocks())["mt9"]["roi1"]["h"].value().toInt();
        QImage *image = _cam->com()->inputFlow()[flow]->getData().toImage(w, h, 16);
        ui->graphicsView->showImage(*image);
        delete image;
    }
}

void MainWindow::setBiSpace()
{
    if(!_cam) return;
    ui->biSpaceHex->setData(_cam->registerData());
}
