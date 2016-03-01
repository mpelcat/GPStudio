#include "model_process.h"

ModelProcess::ModelProcess()
{
}

ModelProcess::~ModelProcess()
{
}

QString ModelProcess::type() const
{
    return "process";
}

ModelProcess *ModelProcess::fromNodeGenerated(const QDomElement &domElement, ModelProcess *process)
{
    if(process==NULL) process = new ModelProcess();

    ModelBlock::fromNodeGenerated(domElement, process);

    return process;
}
