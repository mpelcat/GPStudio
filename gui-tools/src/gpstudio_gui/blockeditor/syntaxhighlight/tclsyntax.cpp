#include "tclsyntax.h"

#include <QDebug>

TCLSyntax::TCLSyntax(QTextDocument *parent)
    : AbstractSyntax(parent)
{
    HighlightingRule rule;

    keywordFormat.setForeground(Qt::darkBlue);
    keywordFormat.setFontWeight(QFont::Bold);
    QStringList keywordPatterns;
    keywordPatterns << "after" << "append" << "array"
                    << "auto_execok" << "auto_import" << "auto_load"
                    << "auto_load_index" << "auto_qualify" << "binary"
                    << "bgerror" << "break" << "catch"
                    << "cd" << "clock" << "close"
                    << "concat" << "continue" << "dde"
                    << "default" << "else" << "elseif"
                    << "encoding" << "eof" << "error"
                    << "eval" << "exec" << "exit"
                    << "expr" << "fblocked" << "fconfigure"
                    << "fcopy" << "file" << "fileevent"
                    << "flush" << "for" << "foreach"
                    << "format" << "gets" << "glob"
                    << "global" << "history" << "if"
                    << "incr" << "info" << "interp"
                    << "join" << "lappend" << "lindex"
                    << "linsert" << "list" << "llength"
                    << "load" << "lrange" << "lreplace"
                    << "lsearch" << "lsort" << "namespace"
                    << "open" << "package" << "pid"
                    << "pkg_mk" << "proc" << "puts"
                    << "pwd" << "read" << "regexp"
                    << "regsub" << "rename" << "resource"
                    << "return" << "scan" << "seek"
                    << "set" << "socket" << "source"
                    << "split" << "string" << "subst"
                    << "switch" << "tcl" << "tell"
                    << "time" << "trace" << "unknown"
                    << "unset" << "update" << "uplevel"
                    << "upvar" << "variable" << "vwait"
                    << "while";
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

    singleLineCommentFormat.setForeground(Qt::red);
    rule.pattern = QRegExp("(#[^\n]*)");
    rule.format = singleLineCommentFormat;
    highlightingRules.append(rule);

    numberFormat.setForeground(QColor(255,69,0));
    rule.pattern = QRegExp("\\b([0-9]+\\.{0,1}[0-9]*)\\b");
    rule.format = numberFormat;
    highlightingRules.append(rule);

    typesFormat.setForeground(QColor(255,48,99));
    rule.pattern = QRegExp("set[\\s\\t]+([a-zA-Z\\_]+[a-zA-Z0-9\\_]*)");
    rule.format = typesFormat;
    highlightingRules.append(rule);
    rule.pattern = QRegExp("(\\$[a-zA-Z\\_]+[a-zA-Z0-9\\_]*)");
    rule.format = typesFormat;
    highlightingRules.append(rule);
}
