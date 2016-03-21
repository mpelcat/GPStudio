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

#ifndef IOLIB_H
#define IOLIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>
#include <QIcon>

class GPSTUDIO_LIB_EXPORT IOLib
{
public:
    IOLib();

    QString name() const;
    void setName(const QString &name);

    QString description() const;
    void setDescription(const QString &description);

    QString categ() const;
    void setCateg(const QString &categ);

    QString path() const;
    void setPath(const QString &path);

    QString configFile() const;
    void setConfigFile(const QString &configFile);

    QString draw() const;
    void setDraw(const QString &draw);

    QIcon icon() const;
    void setIcon(const QIcon &icon);

public:
    static IOLib *readFromFile(const QString &fileName);
    static IOLib *fromDomElement(const QDomElement &domElement);

private:
    QString _name;
    QString _categ;
    QString _path;
    QString _configFile;
    QString _description;
    QString _draw;
    QIcon _icon;
};

#endif // IOLIB_H
