#ifndef CAMERA_H
#define CAMERA_H

#include <QString>
#include <QThread>
#include <QList>

#include "dreamcam_com.h"
#include "cameraio.h"
#include "flow.h"

class DREAMCAMCOM_EXPORT Camera : public QThread
{
    Q_OBJECT
public:
    Camera(const CameraInfo &cameraInfo);
    ~Camera();

    bool isConnected() const;
    void stop();

    //Camera(const CameraInfo &info); TODO

    // void sendFlow(const Flow &flow);
    // bool getFlow(Flow &flow);

    static QVector<CameraInfo> avaibleCams();

    const QList<Flow*> &inputFlow() const;
    QList<Flow*> &inputFlow();
    const QList<Flow*> &outputFlow() const;
    QList<Flow*> &outputFlow();

    CameraIO *cameraIO() const;

    void writeParam(const unsigned int addr, const unsigned int value);
    void writeParam(const unsigned int addr, const unsigned int * data, const unsigned size);

    void askStatus();

signals:
    void flowReadyToRead(int flow);

protected:
    void run();

private:
    CameraIO *_cameraIO;
    bool _start;

    QList<Flow*> _inputFlow;
    QList<Flow*> _outputFlow;

    Flow *_paramFlow;
};

#endif // CAMERA_H
