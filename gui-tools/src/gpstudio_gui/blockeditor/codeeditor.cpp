#include "codeeditor.h"

#include "syntaxhighlight/vhdlsyntax.h"

#include <QDebug>
#include <QKeyEvent>

CodeEditor::CodeEditor(QWidget *parent)
{
    QFont font = QFontDatabase::systemFont(QFontDatabase::FixedFont);
    font.setStyleHint(QFont::TypeWriter);
    setFont(font);
    setTabStopWidth(fontMetrics().width("    "));
    highlight = new VHDLSyntax(this->document());
}

void CodeEditor::keyPressEvent(QKeyEvent *event)
{
    QPlainTextEdit::keyPressEvent(event);

    if (event->key() == Qt::Key_Return || event->key() == Qt::Key_Enter)
    {
        // keep indent
        QString spaces;
        QString previousLine = this->textCursor().block().previous().text();
        QRegExp startSpaces("([\\s\\t]+)");
        if(startSpaces.indexIn(previousLine)==0)
        {
            spaces = startSpaces.cap(1);
            insertPlainText(spaces);
        }
    }
}
