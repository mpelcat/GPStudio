#include "flowdata.h"

#include <QDebug>

FlowData::FlowData(const QByteArray &data)
    : _data(data)
{
}

FlowData::FlowData(const FlowData &other)
    : _data(other._data)
{
   // qDebug()<<"copy FLOWDATA"<<other._data.size();
}

FlowData::FlowData(const QImage &image, const int bitCount, const FlowData::ImageMode imageMode)
{
    Q_UNUSED(bitCount);

    if(imageMode==ImageModeGray)
    {
        for(int y=0; y<image.height(); y++)
        {
            for(int x=0; x<image.width(); x++)
            {
                _data.append((char)0);
                _data.append((unsigned char)qGray(image.pixel(x,y)));
                //_data.append((char)0);
            }
        }
    }
    else
    {
    }
}

const QByteArray &FlowData::data() const
{
    return _data;
}

QByteArray FlowData::getPart(const int size)
{
    QByteArray part = _data.left(size);
    _data.remove(0,size);
    return part;
}

bool FlowData::empty() const
{
    return _data.size()==0;
}

void FlowData::clear()
{
    _data.clear();
}

void FlowData::appendData(const QByteArray &data)
{
    _data.append(data);
}

QImage *FlowData::toImage(const int width, const int height, const int dataSize) const
{
    //Q_UNUSED(dataSize);

    QImage *img = new QImage(width, height, QImage::Format_Indexed8);
    QVector<QRgb> colors;
    for(int i=0; i<256; i++) colors.append(qRgb(i,i,i));
    img->setColorTable(colors);

    //qDebug()<<_data.size()<<width*height;

    /*for(int y=0; y<height; y++)
    {
        for(int x=0; x<width; x++)
        {
            if(((x+y*width)*2+1)<_data.size())
            {
                unsigned value = (unsigned char)_data.data()[(x+y*width)*2+1];

                //if(value==1) value = 255;
                img.setPixel(x,y,value);
            }
        }
    }*/

    //qDebug() << _data.size() << width * height;
    const char *ptr = _data.data();
    if(dataSize==16) ptr++;
    const char *ptrEnd = _data.data()+_data.size();
    for(int y=0; y<height; y++)
    {
        for(int x=0; x<width; x++)
        {
            if(ptr<ptrEnd)
            {

                //if(value==1) value = 255;
                img->setPixel(x,y,(unsigned char)(*ptr));
                ptr+=dataSize/8;
            }
        }
    }

    //memcpy(img->bits(), _data.data(), _data.size());

    return img;
}

QImage *FlowData::toImage(const QSize size, const int dataSize) const
{
    return toImage(size.width(), size.height(), dataSize);
}
