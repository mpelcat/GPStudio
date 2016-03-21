/****************************************************************************
** Copyright (C) 2014 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#include "flowpackage.h"

#include <QDebug>

FlowPackage::FlowPackage(const QByteArray &data)
    : _data(data)
{
}

FlowPackage::FlowPackage(const FlowPackage &other)
    : _data(other._data)
{
    // qDebug()<<"copy FLOWDATA"<<other._data.size();
}

const FlowPackage &FlowPackage::operator=(const FlowPackage &other)
{
    _data = other._data;
    return other;
}

FlowPackage::FlowPackage(const QImage &image, const int bitCount, const FlowPackage::ImageMode imageMode)
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

const QByteArray &FlowPackage::data() const
{
    return _data;
}

QByteArray FlowPackage::getPart(const int size)
{
    QByteArray part = _data.left(size);
    _data.remove(0,size);
    return part;
}

bool FlowPackage::empty() const
{
    return _data.size()==0;
}

void FlowPackage::clear()
{
    _data.clear();
}

void FlowPackage::appendData(const QByteArray &data)
{
    _data.append(data);
}

QImage *FlowPackage::toImage(const int width, const int height, const int dataSize) const
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
                img->setPixel(x,y,(unsigned char)(*ptr));
                ptr+=dataSize/8;
            }
            else
            {
                img->setPixel(x,y,255);
            }
        }
    }

    //memcpy(img->bits(), _data.data(), _data.size());

    return img;
}

QImage *FlowPackage::toImage(const QSize size, const int dataSize) const
{
    return toImage(size.width(), size.height(), dataSize);
}
