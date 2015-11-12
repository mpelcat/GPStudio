#include "process.h"

Process::Process()
{
}

Process::~Process()
{
}

QString Process::type() const
{
    return "process";
}

Process *Process::fromNodeGenerated(const QDomElement &domElement, Process *process)
{
    if(process==NULL) process = new Process();

    Block::fromNodeGenerated(domElement, process);

    return process;
}
