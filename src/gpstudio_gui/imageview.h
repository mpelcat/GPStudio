#ifndef IMAGEVIEW_H
#define IMAGEVIEW_H

#include <QGraphicsView>
#include <opencv2/core/core.hpp>

#include <vector>

#include "gpstudio_gui_common.h"

/**
 * @brief The ImageView class is a QGraphicsView to which show a cv::Mat with capabilities of zoom and move into image.
 * Signal slot viewMoved and setView can be used to syncronize two viewers.
 */
class GPSTUDIO_GUI_EXPORT ImageView : public QGraphicsView
{
    Q_OBJECT
public:
    explicit ImageView(QWidget *parent = 0);

    enum ViewProperty {All              = 0xFF};

    void showImage(const cv::Mat &image, const QString &title=QString());
    void showImage(const QImage &image, const QString &title=QString());
    void showImage(const QPixmap &image, const QString &title=QString());

    unsigned int propertyView() const;
    void setPropertyView(unsigned int propertyView);

protected:
    void wheelEvent(QWheelEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mousePressEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);

signals:
    void viewMoved(const QRect &viewRect);
    void rectDrawed(const QRect &viewRect);

private slots:

private:
    QGraphicsScene *_scene;
    double _currentZoomLevel;
    QPointF _startPos;
    unsigned int _propertyView;
    QGraphicsPixmapItem *_pixmapItem;
};

#endif // IMAGEVIEW_H
