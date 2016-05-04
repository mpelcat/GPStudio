#include "xmlsyntax.h"

#include <QDebug>

XMLSyntax::XMLSyntax(QTextDocument *parent)
    : AbstractSyntax(parent)
{
    HighlightingRule rule;

    keywordFormat.setForeground(Qt::darkBlue);
    keywordFormat.setFontWeight(QFont::Bold);
    rule.pattern = QRegExp("(\\<[/?]{0,1}[a-z]+[\\>]{0,1})");
    rule.format = keywordFormat;
    highlightingRules.append(rule);
    rule.pattern = QRegExp("([a-z]*[/?]{0,1}\\>)");
    rule.format = keywordFormat;
    highlightingRules.append(rule);

    quotationFormat.setForeground(QColor(128,0,128));
    rule.pattern = QRegExp("(\"[^\"]*\")");
    rule.format = quotationFormat;
    highlightingRules.append(rule);

    typesFormat.setForeground(QColor(255,48,99));
    rule.pattern = QRegExp("([a-zA-Z\\_]+)[\\s\\t]*=");
    rule.format = typesFormat;
    highlightingRules.append(rule);

    numberFormat.setForeground(QColor(255,69,0));
    rule.pattern = QRegExp("(\\b[0-9]+\\b)");
    rule.format = numberFormat;
    highlightingRules.append(rule);

    multiLineCommentFormat.setForeground(QColor(0,128,0));
    commentStartExpression = QRegExp("\\<!--");
    commentEndExpression = QRegExp("--\\>");
}

