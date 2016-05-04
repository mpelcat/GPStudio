#include "verilogsyntax.h"

#include <QDebug>

VerilogSyntax::VerilogSyntax(QTextDocument *parent)
    : AbstractSyntax(parent)
{
    HighlightingRule rule;

    keywordFormat.setForeground(Qt::darkBlue);
    keywordFormat.setFontWeight(QFont::Bold);
    QStringList keywordPatterns;
    keywordPatterns << "always" << "assign" << "automatic"
                    << "begin" << "case" << "casex"
                    << "casez" << "cell" << "config"
                    << "deassign" << "default" << "defparam"
                    << "design" << "disable" << "edge"
                    << "else" << "end" << "endcase"
                    << "endconfig" << "endfunction" << "endgenerate"
                    << "endmodule" << "endprimitive" << "endspecify"
                    << "endtable" << "endtask" << "event"
                    << "for" << "force" << "forever"
                    << "fork" << "function" << "generate"
                    << "genvar" << "if" << "ifnone"
                    << "incdir" << "include" << "initial"
                    << "inout" << "input" << "instance"
                    << "join" << "liblist" << "library"
                    << "localparam" << "macromodule" << "module"
                    << "negedge" << "noshowcancelled" << "output"
                    << "parameter" << "posedge" << "primitive"
                    << "pulsestyle_ondetect" << "pulsestyle_onevent" << "reg"
                    << "release" << "repeat" << "scalared"
                    << "showcancelled" << "signed" << "specify"
                    << "specparam" << "strength" << "table"
                    << "task" << "tri0" << "tri1"
                    << "triand" << "trireg" << "unsigned"
                    << "use" << "vectored" << "wait"
                    << "while" << "wire";
    foreach (const QString &pattern, keywordPatterns)
    {
        rule.pattern = QRegExp("\\b("+pattern+")\\b");
        rule.format = keywordFormat;
        highlightingRules.append(rule);
    }

    quotationFormat.setForeground(QColor(128,0,128));
    rule.pattern = QRegExp("(\"[^\"]*\")");
    rule.format = quotationFormat;
    highlightingRules.append(rule);

    singleLineCommentFormat.setForeground(QColor(0,128,0));
    rule.pattern = QRegExp("(//[^\n]*)");
    rule.format = singleLineCommentFormat;
    highlightingRules.append(rule);

    typesFormat.setForeground(QColor(255,48,99));
    QStringList typesPatterns;
    typesPatterns << "types" << "access" << "array"
                  << "bit" << "bit_vector" << "boolean"
                  << "character" << "composite" << "constrained"
                  << "delay_length" << "discrete" << "enumeration"
                  << "file" << "file_open_kind" << "file_open_status"
                  << "floating" << "integer" << "natural"
                  << "physical" << "positive" << "real"
                  << "record" << "scalar" << "severity_level"
                  << "signed" << "std_logic" << "std_logic_vector"
                  << "string" << "time" << "unconstrained"
                  << "unsigned";

    foreach (const QString &pattern, typesPatterns)
    {
        rule.pattern = QRegExp("\\b("+pattern+")\\b");
        rule.format = typesFormat;
        highlightingRules.append(rule);
    }

    numberFormat.setForeground(QColor(255,69,0));
    rule.pattern = QRegExp("\\b([0-9]*'*[dbho]*[0-9]+)\\b");
    rule.format = numberFormat;
    highlightingRules.append(rule);

    multiLineCommentFormat.setForeground(QColor(0,128,0));
    commentStartExpression = QRegExp("/\\*");
    commentEndExpression = QRegExp("\\*/");
}
