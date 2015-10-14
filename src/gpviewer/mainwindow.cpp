#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QDebug>
#include <QImage>
#include <QFileDialog>
#include <QFile>

#include <QDateTime>

#include "property.h"
#include "propertywidgets/propertywidgets.h"
#include "connectnodedialog.h"

#include "cameracom.h"
#include "flowcom.h"
#include "flowdata.h"

#include "datawrapper/gradiantwrapper.h"
#include "datawrapper/harriswrapper.h"


MainWindow::MainWindow(QStringList args) :
    QMainWindow(0),
    ui(new Ui::MainWindow)
{
    _cam = NULL;

    ui->setupUi(this);
    createToolBarAndMenu();
    QMainWindow::setCorner(Qt::TopLeftCorner, Qt::LeftDockWidgetArea);
    QMainWindow::setCorner(Qt::BottomLeftCorner, Qt::LeftDockWidgetArea);

    _lib = new Lib("../../../GPStudio_lib_std");
    ui->blocksView->setLib(_lib);

    _view0 = new ImageView();
    _view1 = new ImageView();
    _view2 = new ImageView();
    _view3 = new ImageView();

    oneViewer();

//    if(QFile::exists("../../../std_project/node_generated.xml")) openNodeGeneratedFile("../../../std_project/node_generated.xml");
//    else
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

    QAction *openDocAction = new QAction("&Open node",this);
    openDocAction->setIcon(QIcon(":/icons/img/open.png"));
    openDocAction->setShortcut(QKeySequence::Open);
    ui->mainToolBar->addAction(openDocAction);
    nodeMenu->addAction(openDocAction);
    connect(openDocAction, SIGNAL(triggered()), this, SLOT(openNode()));

    QAction *connectAction = new QAction("&Connect node",this);
    connectAction->setIcon(QIcon(":/icons/img/connect.png"));
    ui->mainToolBar->addAction(connectAction);
    nodeMenu->addAction(connectAction);
    connect(connectAction, SIGNAL(triggered()), this, SLOT(connectCam()));

    QMenu *viewMenu = ui->menuBar->addMenu("&View");
    QAction *oneViewer = new QAction("&One",this);
    ui->mainToolBar->addAction(oneViewer);
    viewMenu->addAction(oneViewer);
    connect(oneViewer, SIGNAL(triggered()), this, SLOT(oneViewer()));
    QAction *twoViewer = new QAction("&Two",this);
    ui->mainToolBar->addAction(twoViewer);
    viewMenu->addAction(twoViewer);
    connect(twoViewer, SIGNAL(triggered()), this, SLOT(twoViewer()));
    QAction *fourViewer = new QAction("&Four",this);
    ui->mainToolBar->addAction(fourViewer);
    viewMenu->addAction(fourViewer);
    connect(fourViewer, SIGNAL(triggered()), this, SLOT(fourViewer()));

    QMenu *helpMenu = ui->menuBar->addMenu("&Help");

    ui->mainToolBar->addSeparator();
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

    ui->blocksView->loadFromNode(_cam->node());

    connect(_cam, SIGNAL(registerDataChanged()), this, SLOT(setBiSpace()));

    connectCam();
}

void MainWindow::connectCam()
{
    if(_cam)
    {
        ConnectNodeDialog connectNodeDialog(this);
        if(connectNodeDialog.exec()==QDialog::Accepted)
        {
            _cam->connectCam(connectNodeDialog.cameraInfo());

            if(_cam->isConnected())
            {
                connect(_cam->com(), SIGNAL(flowReadyToRead(int)), this, SLOT(viewFlow(int)));
            }
        }
    }
}

void MainWindow::viewFlow(int flow)
{
    int w = (*_cam->paramsBlocks())["mt9"]["roi1"]["w"].value().toInt();
    int h = (*_cam->paramsBlocks())["mt9"]["roi1"]["h"].value().toInt();
    int binning = (*_cam->paramsBlocks())["mt9"]["binning"].value().toInt();
    if(binning==1)
    {
        w/=2;
        h/=2;
    }

    if(flow==0)
    {
        QImage *image = _cam->com()->inputFlow()[flow]->getData().toImage(w, h, 8);
        _view0->showImage(*image);
        delete image;
    }
    if(flow==1)
    {
        QImage *image = _cam->com()->inputFlow()[flow]->getData().toImage(w, h, 16);
        _view1->showImage(*image);
        delete image;
    }
    if(flow==2)
    {
        GradiantWrapper grad;
        grad.setWimg(w);
        grad.setHimg(h);

        int nbin = (*_cam->paramsBlocks())["histogramhw0"]["nbin"].value().toInt();
        grad.setNbBins(nbin);
        int cellsize = (*_cam->paramsBlocks())["histogramhw0"]["cellwidth"].value().toInt();
        grad.setCellSize(cellsize);

        const FlowData &flowData = _cam->com()->inputFlow()[flow]->getData();
        QImage *gradImg = grad.transform(flowData);

//        ui->graphicsView_2->showImage(*gradImg);
         _view2->showImage(*gradImg);
        delete gradImg;
    }
    if(flow==3)
    {
        Harriswrapper harris;

        harris.setHimg(h);
        harris.setWimg(w);

        const FlowData &flowData = _cam->com()->inputFlow()[flow]->getData();
        QImage *harrisImg = harris.transform(flowData);

         _view3->showImage(*harrisImg);
        delete harrisImg;

//        GradiantWrapper grad;
//        grad.setWimg(w);
//        grad.setHimg(h);

//        int nbin = (*_cam->paramsBlocks())["histogramhw0"]["nbin"].value().toInt();
//        grad.setNbBins(nbin);
//        int cellsize = (*_cam->paramsBlocks())["histogramhw0"]["cellwidth"].value().toInt();
//        grad.setCellSize(cellsize);

//        const FlowData &flowData = _cam->com()->inputFlow()[flow]->getData();
//        QImage *gradImg = grad.transform(flowData);

//         _view3->showImage(*gradImg);
//        delete gradImg;
    }


}

void MainWindow::setBiSpace()
{
    if(!_cam) return;
    ui->piSpaceHex->setData(_cam->registerData());
}

void MainWindow::oneViewer()
{
    while(!ui->viewerLayout->isEmpty())
    {
        delete ui->viewerLayout->itemAt(0)->widget();
    }
    _view0 = new ImageView();
    _view1 = new ImageView();
    _view2 = new ImageView();
    _view3 = new ImageView();

    ui->viewerLayout->addWidget(_view0, 0, 0);
    ui->tabWidget->setCurrentIndex(0);
}

void MainWindow::twoViewer()
{
    while(!ui->viewerLayout->isEmpty())
    {
        delete ui->viewerLayout->itemAt(0)->widget();
    }
    _view0 = new ImageView();
    _view1 = new ImageView();
    _view2 = new ImageView();
    _view3 = new ImageView();

    ui->viewerLayout->addWidget(_view0, 0, 0);
    ui->viewerLayout->addWidget(_view1, 0, 1);
    ui->tabWidget->setCurrentIndex(0);
}

void MainWindow::fourViewer()
{
    while(!ui->viewerLayout->isEmpty())
    {
        delete ui->viewerLayout->itemAt(0)->widget();
    }
    _view0 = new ImageView();
    _view1 = new ImageView();
    _view2 = new ImageView();
    _view3 = new ImageView();

    ui->viewerLayout->addWidget(_view0, 0, 0);
    ui->viewerLayout->addWidget(_view1, 0, 1);
    ui->viewerLayout->addWidget(_view2, 1, 0);
    ui->viewerLayout->addWidget(_view3, 1, 1);
    ui->tabWidget->setCurrentIndex(0);
}
