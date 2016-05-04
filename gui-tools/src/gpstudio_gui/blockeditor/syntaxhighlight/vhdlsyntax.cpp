#include "vhdlsyntax.h"

#include <QDebug>

VHDLSyntax::VHDLSyntax(QTextDocument *parent)
    : QSyntaxHighlighter(parent)
{
    HighlightingRule rule;

    keywordFormat.setForeground(Qt::darkBlue);
    //keywordFormat.setFontWeight(QFont::Bold);
    QStringList keywordPatterns;
    keywordPatterns << "\\babs\\b" << "\\baccess\\b" << "\\bafter\\b"
                    << "\\balias\\b" << "\\ball\\b" << "\\band\\b"
                    << "\\barchitecture\\b" << "\\barray\\b" << "\\bassert\\b"
                    << "\\battribute\\b" << "\\bbegin\\b" << "\\bblock\\b"
                    << "\\bbody\\b" << "\\bbuffer\\b" << "\\bbus\\b"
                    << "\\bcase\\b" << "\\bcomponent\\b" << "\\bconfiguration\\b"
                    << "\\bconstant\\b" << "\\bdisconnect\\b" << "\\bdownto\\b"
                    << "\\belse\\b" << "\\belsif\\b" << "\\bend\\b"
                    << "\\bentity\\b" << "\\bexit\\b" << "\\bfile\\b"
                    << "\\bfor\\b" << "\\bfunction\\b" << "\\bgenerate\\b"
                    << "\\bgeneric\\b" << "\\bgroup\\b" << "\\bguarded\\b"
                    << "\\bif\\b" << "\\bimpure\\b" << "\\bin\\b"
                    << "\\binertial\\b" << "\\binout\\b" << "\\bis\\b"
                    << "\\blabel\\b" << "\\blibrary\\b" << "\\blinkage\\b"
                    << "\\bliteral\\b" << "\\bloop\\b" << "\\bmap\\b"
                    << "\\bmod\\b" << "\\bnand\\b" << "\\bnew\\b"
                    << "\\bnext\\b" << "\\bnor\\b" << "\\bnot\\b"
                    << "\\bnull\\b" << "\\bof\\b" << "\\bon\\b"
                    << "\\bopen\\b" << "\\bor\\b" << "\\bothers\\b"
                    << "\\bout\\b" << "\\bpackage\\b" << "\\bport\\b"
                    << "\\bpostponed\\b" << "\\bprocedure\\b" << "\\bprocess\\b"
                    << "\\bpure\\b" << "\\brange\\b" << "\\brecord\\b"
                    << "\\bregister\\b" << "\\breject\\b" << "\\brem\\b"
                    << "\\breport\\b" << "\\breturn\\b" << "\\brol\\b"
                    << "\\bror\\b" << "\\bselect\\b" << "\\bseverity\\b"
                    << "\\bsignal\\b" << "\\bshared\\b" << "\\bsla\\b"
                    << "\\bsll\\b" << "\\bsra\\b" << "\\bsrl\\b"
                    << "\\bsubtype\\b" << "\\bthen\\b" << "\\bto\\b"
                    << "\\btransport\\b" << "\\btype\\b" << "\\bunaffected\\b"
                    << "\\bunits\\b" << "\\buntil\\b" << "\\buse\\b"
                    << "\\bvariable\\b" << "\\bwait\\b" << "\\bwhen\\b"
                    << "\\bwhile\\b" << "\\bwith\\b" << "\\bxnor\\b"
                    << "\\bxor\\b";
    foreach (const QString &pattern, keywordPatterns)
    {
        rule.pattern = QRegExp(pattern);
        rule.format = keywordFormat;
        highlightingRules.append(rule);
    }

    quotationFormat.setForeground(QColor(128,0,128));
    rule.pattern = QRegExp("\"[^\"]*\"");
    rule.format = quotationFormat;
    highlightingRules.append(rule);

    singleLineCommentFormat.setForeground(Qt::red);
    rule.pattern = QRegExp("--[^\n]*");
    rule.format = singleLineCommentFormat;
    highlightingRules.append(rule);

    typesFormat.setForeground(QColor(255,48,99));
    QStringList typesPatterns;
    typesPatterns << "\\btypes\\b" << "\\baccess\\b" << "\\barray\\b"
                  << "\\bbit\\b" << "\\bbit_vector\\b" << "\\bboolean\\b"
                  << "\\bcharacter\\b" << "\\bcomposite\\b" << "\\bconstrained\\b"
                  << "\\bdelay_length\\b" << "\\bdiscrete\\b" << "\\benumeration\\b"
                  << "\\bfile\\b" << "\\bfile_open_kind\\b" << "\\bfile_open_status\\b"
                  << "\\bfloating\\b" << "\\binteger\\b" << "\\bnatural\\b"
                  << "\\bphysical\\b" << "\\bpositive\\b" << "\\breal\\b"
                  << "\\brecord\\b" << "\\bscalar\\b" << "\\bseverity_level\\b"
                  << "\\bsigned\\b" << "\\bstd_logic\\b" << "\\bstd_logic_vector\\b"
                  << "\\bstring\\b" << "\\btime\\b" << "\\bunconstrained\\b"
                  << "\\bunsigned\\b";

    foreach (const QString &pattern, typesPatterns)
    {
        rule.pattern = QRegExp(pattern);
        rule.format = typesFormat;
        highlightingRules.append(rule);
    }

    numberFormat.setForeground(QColor(255,69,0));
    rule.pattern = QRegExp("\\b[0-9]+\\b");
    rule.format = numberFormat;
    highlightingRules.append(rule);
}

void VHDLSyntax::highlightBlock(const QString &text)
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
            highlight.index = index;
            highlight.length = expression.matchedLength();
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
            highlight.index = find;
            highlight.length = expression.matchedLength();
            highlight.rule = partToHighlight.rule;
            partsToHighlight.append(highlight);
            qSort(partsToHighlight);
        }
    }

    setCurrentBlockState(0);
}
