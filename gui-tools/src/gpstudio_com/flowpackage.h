#ifndef FLOWPACKAGE_H
#define FLOWPACKAGE_H

#include <QByteArray>
#include <QList>
#include <QImage>
#include <QMetaType>

#include "gpstudio_com_common.h"

class GPSTUDIO_COM_EXPORT FlowPackage
{
public:
    FlowPackage(const QByteArray &data=QByteArray());
    FlowPackage(const FlowPackage &other);
    const FlowPackage &operator= (const FlowPackage &other);

    enum ImageMode {ImageModeGray, ImageModeColor};
    FlowPackage(const QImage &image, const int bitCount=8, const ImageMode imageMode=ImageModeGray);

    const QByteArray &data() const;
    QByteArray getPart(const int size);

    bool empty() const;
    void clear();

    void appendData(const QByteArray &data);

    QImage *toImage(const int width, const int height, const int dataSize) const;
    QImage *toImage(const QSize size, const int dataSize) const;

private:
    QByteArray _data;
};

Q_DECLARE_METATYPE(FlowPackage)

#endif // FLOWPACKAGE_H
