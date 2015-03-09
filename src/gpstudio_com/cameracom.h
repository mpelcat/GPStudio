#ifndef CAMERA_COM_H
#define CAMERA_COM_H

#include <QString>
#include <QThread>
#include <QList>

#include "gpstudio_com_common.h"
#include "cameraio.h"
#include "flowcom.h"

class GPSTUDIO_COM_EXPORT CameraCom : public QThread
{
    Q_OBJECT
public:
    CameraCom(const CameraInfo &cameraInfo);
    ~CameraCom();

    bool isConnected() const;
    void stop();

    //Camera(const CameraInfo &info); TODO

    // void sendFlow(const Flow &flow);
    // bool getFlow(Flow &flow);

    static QVector<CameraInfo> avaibleCams();

    const QList<FlowCom*> &inputFlow() const;
    QList<FlowCom*> &inputFlow();
    const QList<FlowCom*> &outputFlow() const;
    QList<FlowCom*> &outputFlow();

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

    QList<FlowCom*> _inputFlow;
    QList<FlowCom*> _outputFlow;

    FlowCom *_paramFlow;
};

#endif // CAMERA_COM_H
