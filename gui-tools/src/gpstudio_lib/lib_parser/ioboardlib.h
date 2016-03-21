/****************************************************************************
** Copyright (C) 2016 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#ifndef IOBOARDLIB_H
#define IOBOARDLIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>

class GPSTUDIO_LIB_EXPORT IOBoardLib
{
public:
    IOBoardLib();
    ~IOBoardLib();

    QString name() const;
    void setName(const QString &name);

    QString type() const;
    void setType(const QString &type);

    QString driver() const;
    void setDriver(const QString &driver);

    bool isOptional() const;
    void setOptional(bool isOptional);

    QString group() const;
    void setGroup(const QString &group);

    QString description() const;
    void setDescription(const QString &description);

public:
    static IOBoardLib *fromNodeGenerated(const QDomElement &domElement);
    static QList<IOBoardLib *> listFromNodeGenerated(const QDomElement &domElement);

private:
    QString _name;
    QString _type;
    QString _driver;
    bool _optional;
    QString _group;
    QString _description;
};

#endif // IOBOARDLIB_H
