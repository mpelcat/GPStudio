#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

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

private:
    Ui::MainWindow *ui;

    Camera *_cam;

    ImageView *_view0;
    ImageView *_view1;
    ImageView *_view2;
    ImageView *_view3;

    Lib *_lib;

    void createToolBarAndMenu();
};

#endif // MAINWINDOW_H
