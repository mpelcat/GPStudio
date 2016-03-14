#include "abstractviewer.h"

AbstractViewer::AbstractViewer(FlowViewerInterface *flowViewerInterface)
{

}

AbstractViewer *AbstractViewer::fromDataTypeName(const QString &dataTypeName)
{

    return NULL;
}

const Property &AbstractViewer::properties() const
{
    return _properties;
}
