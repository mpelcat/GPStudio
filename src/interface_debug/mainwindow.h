#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "camerausb.h"
#include "camera.h"

#include <QDateTime>
#include <QTimer>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void on_refreshButton_clicked();
    void on_sendButton_clicked();

    void flowReceive(int flow);

    void cameraChanged(CameraInfo info);

    void on_thresholdSlider_valueChanged(int value);
    void on_imageChooseButton_clicked();

    void on_caphinComboBox_currentIndexChanged(int index);
    void on_usbinComboBox_currentIndexChanged(int index);

    void usbEnable();
    void on_mt9EnableBox_clicked();
    void on_sendMT9Config_clicked();

    void on_left_mt9_clicked();
    void on_right_mt9_clicked();
    void on_down_mt9_clicked();
    void on_up_mt9_clicked();

    void send_mt9_config();

    void on_integtimeMT9_valueChanged(int value);
    void on_aemt9_box_toggled(bool checked);

    void fpsUpdate();

protected:
    bool event(QEvent *event);

private:
    Ui::MainWindow *ui;
    Camera *_cam;
    int pnb;

    QSize _size;
    QSize _sizeViewer;

    QDateTime _time;

    // fps
    QTimer fpsTimer;
    unsigned fpsCount;
};

#endif // MAINWINDOW_H
