#ifndef HARRISWRAPPER_H
#define HARRISWRAPPER_H

#include "gpstudio_lib_common.h"

#include "datawrapper.h"

#include <QImage>

class GPSTUDIO_LIB_EXPORT Harriswrapper
{
public:
    Harriswrapper();

    virtual QImage *transform(const FlowPackage &data);

    int wimg() const;
    void setWimg(int wimg);

    int himg() const;
    void setHimg(int himg);

private:
    int _wimg, _himg;

};

#endif // HARRISWRAPPER_H
