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

#ifndef VHDLSYNTAX_H
#define VHDLSYNTAX_H

#include "gpstudio_gui_common.h"

#include <QSyntaxHighlighter>

class GPSTUDIO_GUI_EXPORT VHDLSyntax : public QSyntaxHighlighter
{
    Q_OBJECT
public:
    VHDLSyntax(QTextDocument *parent = 0);

protected:
    void highlightBlock(const QString &text) Q_DECL_OVERRIDE;

private:
    struct HighlightingRule
    {
        QRegExp pattern;
        QTextCharFormat format;
    };
    QVector<HighlightingRule> highlightingRules;
    struct PartToHighlight
    {
        VHDLSyntax::HighlightingRule rule;
        int index;
        int length;
    };
    friend bool operator<(const VHDLSyntax::PartToHighlight &t1, const VHDLSyntax::PartToHighlight &t2);

    QTextCharFormat keywordFormat;
    QTextCharFormat singleLineCommentFormat;
    QTextCharFormat quotationFormat;
    QTextCharFormat typesFormat;
    QTextCharFormat numberFormat;
};

inline bool operator<(const VHDLSyntax::PartToHighlight &t1, const VHDLSyntax::PartToHighlight &t2)
{
    return t1.index<t2.index;
}

#endif // VHDLSYNTAX_H
