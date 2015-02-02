#include "imageview.h"

#include <QWheelEvent>
#include <qmath.h>

#include <QGraphicsPixmapItem>
#include <QImage>
#include <QDebug>
#include <QMouseEvent>

using namespace cv;

ImageView::ImageView(QWidget *parent) :
    QGraphicsView(parent)
{
    _scene = new QGraphicsScene();
    setScene(_scene);

    _currentZoomLevel = 1;

    _propertyView = All;
    _pixmapItem = _scene->addPixmap(QPixmap());
}

void ImageView::showImage(const Mat &image, const QString &title)
{

    if(image.type()==CV_8U)
    {
        QImage qimg((uchar*)image.data, image.cols, image.rows, QImage::Format_Indexed8);
        QVector<QRgb> colors;
        for(unsigned short c=0; c<256; c++) colors.append(qRgb(c,c,c));
        qimg.setColorTable(colors);
        showImage(qimg, title);
    }
    if(image.type()==CV_64F || image.type()==CV_32F)
    {
        Mat imageChar;
        double minVal, maxVal;
        minMaxLoc(image, &minVal, &maxVal);
        image.convertTo(imageChar, CV_8U, 255.0/(maxVal - minVal), -minVal * 255.0/(maxVal - minVal));

        /*QImage qimg((uchar*)imageChar.data, imageChar.cols, imageChar.rows, QImage::Format_Indexed8);
        QVector<QRgb> colors;
        for(unsigned short c=0; c<256; c++) colors.append(qRgb(c,c,c));
        qimg.setColorTable(colors);*/

        QImage qimg(imageChar.cols, imageChar.rows, QImage::Format_Indexed8);
        QVector<QRgb> colors;
        for(unsigned short c=0; c<256; c++) colors.append(qRgb(c,c,c));
        qimg.setColorTable(colors);
        for(int x=0; x<imageChar.cols; x++)
        {
            for(int y=0; y<imageChar.rows; y++)
            {
                qimg.setPixel(x, y, imageChar.at<unsigned char>(y,x));
            }
        }
        showImage(qimg, title);
    }
}

void ImageView::showImage(const QImage &image, const QString &title)
{
    showImage(QPixmap::fromImage(image), title);
}

void ImageView::showImage(const QPixmap &image, const QString &title)
{
    _pixmapItem->setPixmap(image);

    // add title to image
    QGraphicsSimpleTextItem *text=_scene->addSimpleText(title);
    text->setPos((_pixmapItem->pixmap().width()-text->boundingRect().width())/2, -text->boundingRect().height()-10);
}

void ImageView::wheelEvent(QWheelEvent *event)
{
    int numDegrees = event->delta() / 8;
    int numSteps = numDegrees / 15;
    double zoom = qPow(1.2,numSteps);

    _currentZoomLevel *= zoom;
    scale(zoom, zoom);

    QRect viewRect(mapToScene(0, 0).toPoint(), mapToScene(frameRect().bottomRight()).toPoint());
    emit viewMoved(viewRect);
}

void ImageView::mouseMoveEvent(QMouseEvent *event)
{
    if(event->buttons() & Qt::LeftButton)
    {
        QPoint dep = (_startPos-mapToScene(event->pos())).toPoint();
        QRect viewRect(mapToScene(0, 0).toPoint(), mapToScene(frameRect().bottomRight()).toPoint());
        viewRect.translate(dep);
        centerOn(viewRect.center());
        emit viewMoved(viewRect);
    }
    QGraphicsView::mouseMoveEvent(event);
}

void ImageView::mousePressEvent(QMouseEvent *event)
{
    if(event->buttons() & Qt::LeftButton)
    {
        event->accept();
        _startPos = mapToScene(event->pos());
        setCursor(Qt::ClosedHandCursor);
    }
    else if(event->button() & Qt::RightButton)
    {
        _startPos = mapToScene(event->pos());
    }

    QGraphicsView::mousePressEvent(event);
}

void ImageView::mouseReleaseEvent(QMouseEvent *event)
{
    if(event->button() & Qt::RightButton)
    {
        emit rectDrawed(QRect(_startPos.toPoint(), mapToScene(event->pos()).toPoint()).normalized());
    }
    unsetCursor();
    QGraphicsView::mouseReleaseEvent(event);
}

unsigned int ImageView::propertyView() const
{
    return _propertyView;
}

void ImageView::setPropertyView(unsigned int propertyView)
{
    _propertyView = propertyView;
}

