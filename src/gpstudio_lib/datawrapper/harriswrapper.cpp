#include "harriswrapper.h"
#include <QDebug>
Harriswrapper::Harriswrapper()
{
}

QImage *Harriswrapper::transform(const FlowData &data)
{
    QImage *visu = new QImage(_wimg, _himg, QImage::Format_RGB16);

    visu->fill(Qt::black);

    QRect imageRect = QRect(QPoint(0,0), visu->size());

//    QPainter p;
//    p.begin(&_harrisimage);

    //qDebug() << flow.data().size() << flow.data().mid(0,32).toHex();

    if(data.data().size() <7) return visu;
//    unsigned nb_patch = (unsigned char)flow.data()[3];
    unsigned nb_patch = (unsigned char)data.data()[1]*255 + (unsigned char)data.data()[3];
    bool partial_packet = (data.data()[1] & 0x80);

    unsigned patch_size= (unsigned char)data.data()[5];

//    qDebug() << "nb_patch: "<< nb_patch <<
//                "patch_size: "<< patch_size <<
//                "partial_packet: "<< partial_packet;

    if(nb_patch == 0 || nb_patch > 200) return visu;

    int offset = 7;
    for (int cnt=0; cnt < nb_patch-1; cnt++)
    {

        if(offset+8+31*31*2+1>data.data().size()) return visu;
        unsigned patch_y = (unsigned char) (data.data()[offset]*255) + (unsigned char) (data.data()[offset+2]) ;
        offset+=4;
        unsigned patch_x = (unsigned char) (data.data()[offset]*255) + (unsigned char) (data.data()[offset+2]);
        offset+=4;
        //qDebug() << "X" << patch_x << "Y" << patch_y;

        QRect patchRect = QRect(patch_x-15, patch_y-15, 31, 31);
        if(imageRect.contains(patchRect))
        {
            for(int y=0; y<31; y++)
            {
                for(int x=0; x<31; x++)
                {
                    QPoint p(x,y);
                    unsigned pix = (unsigned char) (data.data()[offset]);
                    visu->setPixel(p+patchRect.topLeft(),qRgb(pix,pix,pix));
                    offset+=2;
                }
            }
        }
    }
    return visu;

}

int Harriswrapper::wimg() const
{
    return _wimg;
}

void Harriswrapper::setWimg(int wimg)
{
    _wimg = wimg;
}

int Harriswrapper::himg() const
{
    return _himg;
}

void Harriswrapper::setHimg(int himg)
{
    _himg = himg;
}
