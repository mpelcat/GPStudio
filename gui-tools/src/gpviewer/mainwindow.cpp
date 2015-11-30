#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QDebug>
#include <QImage>
#include <QFileDialog>
#include <QFile>
#include <QtWidgets>

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

    _lib = new Lib("../");
    ui->blocksView->setLib(_lib);

    if(args.size()>1)
    {
        if(QFile::exists(args[1])) openNodeGeneratedFile(args[1]);
    }

    ui->scriptDock->close();
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

    // ============= View =============
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

    viewMenu->addSeparator();
    viewMenu->addAction(ui->paramsDock->toggleViewAction());
    viewMenu->addAction(ui->scriptDock->toggleViewAction());

    // ============= Windows =============
    _winMenu = ui->menuBar->addMenu("&Windows");
    _closeAct = new QAction(tr("Cl&ose"), this);
    _closeAct->setStatusTip(tr("Close the active window"));
    connect(_closeAct, SIGNAL(triggered()), ui->mdiArea, SLOT(closeActiveSubWindow()));

    _closeAllAct = new QAction(tr("Close &All"), this);
    _closeAllAct->setStatusTip(tr("Close all the windows"));
    connect(_closeAllAct, SIGNAL(triggered()), ui->mdiArea, SLOT(closeAllSubWindows()));

    _tileAct = new QAction(tr("&Tile"), this);
    _tileAct->setStatusTip(tr("Tile the windows"));
    connect(_tileAct, SIGNAL(triggered()), ui->mdiArea, SLOT(tileSubWindows()));

    _cascadeAct = new QAction(tr("&Cascade"), this);
    _cascadeAct->setStatusTip(tr("Cascade the windows"));
    connect(_cascadeAct, SIGNAL(triggered()), ui->mdiArea, SLOT(cascadeSubWindows()));

    _nextAct = new QAction(tr("Ne&xt"), this);
    _nextAct->setShortcuts(QKeySequence::NextChild);
    _nextAct->setStatusTip(tr("Move the focus to the next window"));
    connect(_nextAct, SIGNAL(triggered()), ui->mdiArea, SLOT(activateNextSubWindow()));

    _previousAct = new QAction(tr("Pre&vious"), this);
    _previousAct->setShortcuts(QKeySequence::PreviousChild);
    _previousAct->setStatusTip(tr("Move the focus to the previous window"));
    connect(_previousAct, SIGNAL(triggered()), ui->mdiArea, SLOT(activatePreviousSubWindow()));

    updateWindowsMenu();
    connect(ui->mdiArea, SIGNAL(subWindowActivated(QMdiSubWindow*)), this, SLOT(updateWindowsMenu()));

    // ============= Help =============
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

    setupViewers(2);

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
            const CameraInfo &cameraInfo = connectNodeDialog.cameraInfo();

            if(cameraInfo.isValid())
            {
                _cam->connectCam(cameraInfo);

                if(_cam->isConnected())
                {
                    connect(_cam->com(), SIGNAL(flowReadyToRead(int)), this, SLOT(viewFlow(int)));
                }
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

    if(flow>=_viewers.size()) return;

    if(flow==0)
    {
        QImage *image = _cam->com()->inputFlow()[flow]->getData().toImage(w, h, 8);
        _viewers[0]->showImage(*image);
        delete image;
    }
    if(flow==1)
    {
        QImage *image = _cam->com()->inputFlow()[flow]->getData().toImage(w, h, 16);
        _viewers[1]->showImage(*image);
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

        _viewers[2]->showImage(*gradImg);
        delete gradImg;
    }
    if(flow==3)
    {
        Harriswrapper harris;

        harris.setHimg(h);
        harris.setWimg(w);

        const FlowData &flowData = _cam->com()->inputFlow()[flow]->getData();
        QImage *harrisImg = harris.transform(flowData);

         _viewers[3]->showImage(*harrisImg);
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
    if(!_cam->com()) return;
    ui->piSpaceHex->setData(_cam->registerData());
}

void MainWindow::oneViewer()
{
    setupViewers(1);
    ui->mdiArea->tileSubWindows();
}

void MainWindow::twoViewer()
{
    setupViewers(2);
    ui->tabWidget->setCurrentIndex(0);
}

void MainWindow::fourViewer()
{
    setupViewers(4);
    ui->tabWidget->setCurrentIndex(0);
}

void MainWindow::updateWindowsMenu()
{
    _winMenu->clear();
    _winMenu->addAction(_closeAct);
    _winMenu->addAction(_closeAllAct);
    _winMenu->addSeparator();
    _winMenu->addAction(_tileAct);
    _winMenu->addAction(_cascadeAct);
    _winMenu->addSeparator();
    _winMenu->addAction(_nextAct);
    _winMenu->addAction(_previousAct);

    QList<QMdiSubWindow *> windows = ui->mdiArea->subWindowList();

    for (int i = 0; i < windows.size(); ++i)
    {
        QMdiSubWindow *child = windows.at(i);

        QString text;
        if (i < 9) text = tr("&%1 %2").arg(i + 1).arg(child->windowTitle());
        else text = tr("%1 %2").arg(i + 1).arg(child->windowTitle());
        QAction *action  = _winMenu->addAction(text);
        action->setCheckable(true);
        action->setChecked(child == ui->mdiArea->activeSubWindow());
    }
}

void MainWindow::setupViewers(int count)
{
    ui->mdiArea->closeAllSubWindows();
    _viewers.clear();

    for(int i=count-1; i>=0; i--)
    {
        ImageView *viewer = new ImageView();
        viewer->setWindowTitle(QString("Flow %1").arg(i));
        viewer->setFlowNumber(i);
        _viewers.insert(i, viewer);
        QMdiSubWindow * windows = ui->mdiArea->addSubWindow(viewer);
        windows->show();
    }

    ui->mdiArea->tileSubWindows();
}
