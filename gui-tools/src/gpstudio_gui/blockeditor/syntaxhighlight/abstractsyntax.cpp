#include "abstractsyntax.h"

#include <QDebug>

AbstractSyntax::AbstractSyntax(QTextDocument *parent)
    : QSyntaxHighlighter(parent)
{
}

void AbstractSyntax::highlightBlock(const QString &text)
{
    QList<PartToHighlight> partsToHighlight;
    PartToHighlight highlight;

    partsToHighlight.clear();
    foreach (const HighlightingRule &rule, highlightingRules)
    {
        QRegExp expression(rule.pattern);
        int index = expression.indexIn(text);
        if (index >= 0)
        {
            highlight.index = expression.pos(1);
            highlight.length = expression.cap(1).length();
            highlight.rule = rule;
            partsToHighlight.append(highlight);
        }
    }

    int index=0;
    qSort(partsToHighlight);
    while (!partsToHighlight.isEmpty())
    {
        PartToHighlight partToHighlight = partsToHighlight.takeFirst();

        // highlight if needed
        if(partToHighlight.index>=index)
        {
            setFormat(partToHighlight.index, partToHighlight.length, partToHighlight.rule.format);
            index = partToHighlight.index + partToHighlight.length;
        }

        // update part
        QRegExp expression(partToHighlight.rule.pattern);
        int find = expression.indexIn(text, index);
        if (find >= 0)
        {
            highlight.index = expression.pos(1);
            highlight.length = expression.cap(1).length();
            highlight.rule = partToHighlight.rule;
            partsToHighlight.append(highlight);
            qSort(partsToHighlight);
        }
    }
    setCurrentBlockState(0);

    if(!commentStartExpression.isEmpty() && !commentEndExpression.isEmpty())
    {
        int startIndex = 0;
        if (previousBlockState() != 1)
            startIndex = commentStartExpression.indexIn(text);

        while (startIndex >= 0)
        {
            int endIndex = commentEndExpression.indexIn(text, startIndex);
            int commentLength;
            if (endIndex == -1)
            {
                setCurrentBlockState(1);
                commentLength = text.length() - startIndex;
            }
            else
                commentLength = endIndex - startIndex + commentEndExpression.matchedLength();
            setFormat(startIndex, commentLength, multiLineCommentFormat);
            startIndex = commentStartExpression.indexIn(text, startIndex + commentLength);
        }
    }
}
