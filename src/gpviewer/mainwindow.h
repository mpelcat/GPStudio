#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

#include "camera.h"

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

private:
    Ui::MainWindow *ui;

    Camera *_cam;

    void createToolBarAndMenu();
};

#endif // MAINWINDOW_H
