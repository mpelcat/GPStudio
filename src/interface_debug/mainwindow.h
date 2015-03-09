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
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void openNodeGeneratedFile(const QString fileName);

protected:
    bool event(QEvent *event);

private slots:
    void connectCam();
    void viewFlow(int flow);

private:
    Ui::MainWindow *ui;

    Camera *_cam;

    void createToolBarAndMenu();
};

#endif // MAINWINDOW_H
