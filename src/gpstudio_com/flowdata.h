#ifndef FLOWDATA_H
#define FLOWDATA_H

#include <QByteArray>
#include <QList>
#include <QImage>
#include <QMetaType>

#include "gpstudio_com_common.h"

class GPSTUDIO_COM_EXPORT FlowData
{
public:
    FlowData(const QByteArray &data=QByteArray());

    enum ImageMode {ImageModeGray, ImageModeColor};
    FlowData(const QImage &image, const int bitCount=8, const ImageMode imageMode=ImageModeGray);

    const QByteArray &data() const;
    QByteArray getPart(const int size);

    bool empty() const;
    void clear();

    void appendData(QByteArray data);

    QImage toImage(const int width, const int height, const int dataSize);
    QImage toImage(const QSize size, const int dataSize);

private:
    QByteArray _data;
};

Q_DECLARE_METATYPE(FlowData)

#endif // FLOWDATA_H
