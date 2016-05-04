#include "vhdlsyntax.h"

#include <QDebug>

VHDLSyntax::VHDLSyntax(QTextDocument *parent)
    : AbstractSyntax(parent)
{
    HighlightingRule rule;

    keywordFormat.setForeground(Qt::darkBlue);
    keywordFormat.setFontWeight(QFont::Bold);
    QStringList keywordPatterns;
    keywordPatterns << "abs" << "access" << "after"
                    << "alias" << "all" << "and"
                    << "architecture" << "array" << "assert"
                    << "attribute" << "begin" << "block"
                    << "body" << "buffer" << "bus"
                    << "case" << "component" << "configuration"
                    << "constant" << "disconnect" << "downto"
                    << "else" << "elsif" << "end"
                    << "entity" << "exit" << "file"
                    << "for" << "function" << "generate"
                    << "generic" << "group" << "guarded"
                    << "if" << "impure" << "in"
                    << "inertial" << "inout" << "is"
                    << "label" << "library" << "linkage"
                    << "literal" << "loop" << "map"
                    << "mod" << "nand" << "new"
                    << "next" << "nor" << "not"
                    << "null" << "of" << "on"
                    << "open" << "or" << "others"
                    << "out" << "package" << "port"
                    << "postponed" << "procedure" << "process"
                    << "pure" << "range" << "record"
                    << "register" << "reject" << "rem"
                    << "report" << "return" << "rol"
                    << "ror" << "select" << "severity"
                    << "signal" << "shared" << "sla"
                    << "sll" << "sra" << "srl"
                    << "subtype" << "then" << "to"
                    << "transport" << "type" << "unaffected"
                    << "units" << "until" << "use"
                    << "variable" << "wait" << "when"
                    << "while" << "with" << "xnor"
                    << "xor";
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
    rule.pattern = QRegExp("(--[^\n]*)");
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
    rule.pattern = QRegExp("\\b([0-9]+)\\b");
    rule.format = numberFormat;
    highlightingRules.append(rule);
}
