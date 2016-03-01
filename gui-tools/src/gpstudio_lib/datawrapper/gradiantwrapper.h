#ifndef GRADIANTWRAPPER_H
#define GRADIANTWRAPPER_H

#include "gpstudio_lib_common.h"

#include "datawrapper.h"

class GPSTUDIO_LIB_EXPORT GradiantWrapper : public DataWrapper
{
public:
    GradiantWrapper();
    ~GradiantWrapper();

    virtual QImage *transform(const FlowPackage &data);

    int nbBins() const;
    void setNbBins(int nbBins);

    int cellSize() const;
    void setCellSize(int cellSize);

    int wimg() const;
    void setWimg(int wimg);

    int himg() const;
    void setHimg(int himg);

private:
    int _nbBins;
    int _cellSize;
    int _wimg;
    int _himg;
};

#endif // GRADIANTWRAPPER_H
