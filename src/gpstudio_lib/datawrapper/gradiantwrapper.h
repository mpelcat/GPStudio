#ifndef GRADIANTWRAPPER_H
#define GRADIANTWRAPPER_H

#include "gpstudio_lib_common.h"

#include "datawrapper.h"

class GPSTUDIO_LIB_EXPORT GradiantWrapper : public DataWrapper
{
public:
    GradiantWrapper();
    ~GradiantWrapper();

    QImage *transform(QImage *input);

    int nbBins() const;
    void setNbBins(int nbBins);

    int cellSize() const;
    void setCellSize(int cellSize);

    int ximg() const;
    void setXimg(int ximg);

    int yimg() const;
    void setYimg(int yimg);

private:
    int _nbBins;
    int _cellSize;
    int _ximg;
    int _yimg;
};

#endif // GRADIANTWRAPPER_H
