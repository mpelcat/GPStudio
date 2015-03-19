#include "gpnodeproject.h"

GPNodeProject::GPNodeProject()
{
    //if(QFile::exists("../../../std_project/node_generated.xml")) openNodeGeneratedFile("../../../std_project/node_generated.xml");
    _lib = new Lib("../../../GPStudio_lib_std");
}

GPNodeProject::~GPNodeProject()
{
    delete _lib;
}

Lib *GPNodeProject::lib() const
{
    return _lib;
}

QString GPNodeProject::name() const
{
    return _name;
}

void GPNodeProject::setName(const QString &name)
{
    _name = name;
}
