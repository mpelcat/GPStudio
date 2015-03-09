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

#include "../../../std_project/params.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    _cam = NULL;

    ui->setupUi(this);
    createToolBarAndMenu();

    if(QFile::exists("../../../std_project/node_generated.xml")) openNodeGeneratedFile("../../../std_project/node_generated.xml");
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

void MainWindow::createToolBarAndMenu()
{
    // ============= File =============
    QMenu *nodeMenu = ui->menuBar->addMenu("&Node");

    QAction *openDocAction = new QAction("&Open",this);
    openDocAction->setIcon(QIcon(":/icons/img/open.png"));
    openDocAction->setShortcut(QKeySequence::Open);
    ui->mainToolBar->addAction(openDocAction);
    nodeMenu->addAction(openDocAction);

    QAction *connectAction = new QAction("&Connect node",this);
    nodeMenu->addAction(connectAction);
    connect(connectAction, SIGNAL(triggered()), this, SLOT(connectCam()));
}

void MainWindow::openNodeGeneratedFile(const QString fileName)
{
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
}

void MainWindow::connectCam()
{
    ConnectNodeDialog connectNodeDialog(this);
    connectNodeDialog.exec();
    _cam->connectCam(connectNodeDialog.cameraInfo());
    connect(_cam->com(), SIGNAL(flowReadyToRead(int)), this, SLOT(viewFlow(int)));

    _cam->com()->writeParam(USB_STATUS, 1);
    _cam->com()->writeParam(USB_FLOW_IN0, 1);
}

void MainWindow::viewFlow(int flow)
{
    if(flow==0)
    {
        QImage *image = _cam->com()->inputFlow()[flow]->getData().toImage(320, 240, 16);
        ui->graphicsView->showImage(*image);
        delete image;
    }
}
