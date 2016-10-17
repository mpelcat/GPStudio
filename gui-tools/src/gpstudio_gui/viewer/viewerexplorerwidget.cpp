#include "viewerexplorerwidget.h"

#include <QLayout>
#include <QGroupBox>
#include <QDebug>

ViewerExplorerWidget::ViewerExplorerWidget(QWidget *parent) : QWidget(parent)
{
    _project = NULL;

    setupWidgets();
}

void ViewerExplorerWidget::attachProject(GPNodeProject *project)
{
    _project = project;

    if(_project->camera())
    {
        //qDebug()<<_project->camera()->comBlock();
        _flowItemModel->addBlock(_project->camera()->block("usb"));
        _flowTreeView->expandAll();
    }
}

GPNodeProject *ViewerExplorerWidget::project() const
{
    return _project;
}

void ViewerExplorerWidget::setupWidgets()
{
    if(layout())
        layout()->deleteLater();

    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    // flow list
    QGroupBox *groupBox = new QGroupBox("Com flows");
    QLayout *layoutBox = new QVBoxLayout();
    layoutBox->setContentsMargins(0,10,0,0);
    _flowItemModel = new CameraItemModelNoSorted();
    _flowTreeView = new QTreeView();
    _flowTreeView->setModel(_flowItemModel);
    _flowTreeView->setSortingEnabled(true);
    layoutBox->addWidget(_flowTreeView);
    groupBox->setLayout(layoutBox);
    layout->addWidget(groupBox);

    // flow list
    QGroupBox *groupBox2 = new QGroupBox("Com flows");
    QLayout *layoutBox2 = new QVBoxLayout();
    layoutBox2->setContentsMargins(0,10,0,0);
    _flowItemModel = new CameraItemModelNoSorted();
    _flowTreeView = new QTreeView();
    _flowTreeView->setModel(_flowItemModel);
    _flowTreeView->setSortingEnabled(true);
    layoutBox2->addWidget(_flowTreeView);
    groupBox2->setLayout(layoutBox2);
    layout->addWidget(groupBox2);

    setLayout(layout);
}
