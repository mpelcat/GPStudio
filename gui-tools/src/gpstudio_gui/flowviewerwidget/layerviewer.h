#ifndef LAYERVIEWER_H
#define LAYERVIEWER_H

#include "gpstudio_gui_common.h"

#include "abstractviewer.h"

class GPSTUDIO_GUI_EXPORT LayerViewer : public AbstractViewer
{
public:
    LayerViewer(FlowViewerInterface *flowViewerInterface);

protected:
    virtual void setupWidgets();
};

#endif // LAYERVIEWER_H
