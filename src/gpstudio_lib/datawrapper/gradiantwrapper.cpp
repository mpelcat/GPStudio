#include "gradiantwrapper.h"

#include <math.h>
#include <QPainter>

GradiantWrapper::GradiantWrapper()
{

}

GradiantWrapper::~GradiantWrapper()
{

}

QImage *GradiantWrapper::transform(QImage *input)
{
    QImage *visu = new QImage(_ximg, _yimg, QImage::Format_RGB16);
    /*QVector<QRgb> colors;
    for(int i=0; i<256; i++) colors.append(qRgb(i,i,i));
    visu->setColorTable(colors);*/

    int cells_in_x_dir = _ximg / _cellSize;
    int cells_in_y_dir = _yimg / _cellSize;
    float radRangeForOneBin = 3.1415/(float)_nbBins; // dividing 180° into 9 bins, how large (in rad) is one bin?

    float zoomFac = 1;
    visu->fill(Qt::black);

    QPainter p(visu);

    for (int celly=0; celly < cells_in_y_dir; celly++)
    {
        for (int cellx=0; cellx < cells_in_x_dir; cellx++)
        {
            int32_t drawX = cellx * _cellSize;
            int32_t drawY = celly * _cellSize;

            int32_t mx = drawX + _cellSize/2;
            int32_t my = drawY + _cellSize/2;

            // draw in each cell all 9 gradient strengths
            for (int bin=0; bin<_nbBins; bin++)
            {
                int currentGradStrength = qGray( input->pixel(cellx*_nbBins + bin , celly));

                // no line to draw?
                if (currentGradStrength==0)
                    continue;

                float currRad = bin * radRangeForOneBin + radRangeForOneBin/2;

                float dirVecX = cos( currRad );
                float dirVecY = sin( currRad );
                float maxVecLen = _cellSize/2;
                float scale = 1; // just a visualization scale, to see the lines better

                // compute line coordinates
                float x1 = mx - dirVecX * maxVecLen * scale;
                float y1 = my - dirVecY * maxVecLen * scale;
                float x2 = mx + dirVecX * maxVecLen * scale;
                float y2 = my + dirVecY * maxVecLen * scale;

                // draw gradient visualization

                p.setPen(QPen(QColor(currentGradStrength,currentGradStrength,currentGradStrength,255)));
                //p.setBrush(QBrush(QColor(Qt::color0), Qt::NoBrush));
                p.drawLine(QPoint(x1*zoomFac,y1*zoomFac), QPoint(x2*zoomFac,y2*zoomFac));
            } // for (all bins)
        } // for (cellx)
    } // for (celly)

    delete input;
    p.end();

    return visu;
}

int GradiantWrapper::nbBins() const
{
    return _nbBins;
}

void GradiantWrapper::setNbBins(int nbBins)
{
    _nbBins = nbBins;
}

int GradiantWrapper::cellSize() const
{
    return _cellSize;
}

void GradiantWrapper::setCellSize(int cellSize)
{
    _cellSize = cellSize;
}

int GradiantWrapper::ximg() const
{
    return _ximg;
}

void GradiantWrapper::setXimg(int ximg)
{
    _ximg = ximg;
}
int GradiantWrapper::yimg() const
{
    return _yimg;
}

void GradiantWrapper::setYimg(int yimg)
{
    _yimg = yimg;
}
