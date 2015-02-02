#ifndef CAMERAUSB_H
#define CAMERAUSB_H

#include "dreamcam_com.h"
#include "cameraio.h"

#include <../../thirdparts/libusb-1.0/libusb.h>

class DREAMCAMCOM_EXPORT CameraUSB : public CameraIO
{
public:
    const static uint16_t vendorId = 0x04B4;
    const static uint16_t productId = 0x1003;
    const static int EP2 = 0x02;
    const static int EP6 = 0x86;
    const static int InterfaceNumber = 0x00;

    CameraUSB();
    virtual ~CameraUSB();

    bool connect(const CameraInfo &info=CameraInfo());
    bool disconnect();
    bool resetDevice();
    bool isConnected() const;

    QByteArray read(const int timeOut=1000);
    bool write(const QByteArray &array, const int timeOut=1000);

    static QVector<CameraInfo> avaibleCams();

    int sizePacket() const {return 512;}

    int status() const;

private:
    void flush();

private:
    libusb_context *_ctx;
    libusb_device_handle *_devHandle;

};

#endif // CAMERAUSB_H
