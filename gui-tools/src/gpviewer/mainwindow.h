#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMdiSubWindow>

#include "camera.h"
#include "imageview.h"
#include "lib_parser/lib.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QStringList args);
    ~MainWindow();

    void openNodeGeneratedFile(const QString fileName);

protected:
    bool event(QEvent *event);

private slots:
    void openNode();

    void connectCam();
    void viewFlow(int flow);

    void setBiSpace();

    void oneViewer();
    void twoViewer();
    void fourViewer();

    void updateWindowsMenu();

private:
    Ui::MainWindow *ui;

    Camera *_cam;

    // viewer
    void setupViewers();
    QMap<int, ImageView *> _viewers;

    Lib *_lib;

    // menu and toolbar
    void createToolBarAndMenu();
    QMenu *_winMenu;
    QAction *_closeAct;
    QAction *_closeAllAct;
    QAction *_tileAct;
    QAction *_cascadeAct;
    QAction *_nextAct;
    QAction *_previousAct;
};

#endif // MAINWINDOW_H
