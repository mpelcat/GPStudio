#include "codeeditor.h"

#include "syntaxhighlight/vhdlsyntax.h"
#include "syntaxhighlight/xmlsyntax.h"
#include "syntaxhighlight/verilogsyntax.h"
#include "syntaxhighlight/tclsyntax.h"

#include <QDebug>
#include <QFileInfo>
#include <QKeyEvent>

CodeEditor::CodeEditor(QWidget *parent)
    : QPlainTextEdit(parent)
{
    QFont font = QFontDatabase::systemFont(QFontDatabase::FixedFont);
    font.setStyleHint(QFont::TypeWriter);
    setFont(font);
    setTabStopWidth(fontMetrics().width("    "));
    setLineWrapMode(QPlainTextEdit::NoWrap);
    highlight = 0;
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

void CodeEditor::loadFileCode(QString file)
{
    clear();

    if(highlight)
        highlight->deleteLater();

    QFile fileIO(file);
    if(fileIO.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        insertPlainText(fileIO.readAll());
        fileIO.close();
    }

    QFileInfo info(fileIO);
    if(VHDLSyntax::extensions().contains(info.suffix()))
    {
        highlight = new VHDLSyntax(this->document());
    }
    else if(XMLSyntax::extensions().contains(info.suffix()))
    {
        highlight = new XMLSyntax(this->document());
    }
    else if(VerilogSyntax::extensions().contains(info.suffix()))
    {
        highlight = new VerilogSyntax(this->document());
    }
    else if(TCLSyntax::extensions().contains(info.suffix()))
    {
        highlight = new TCLSyntax(this->document());
    }
    else
        highlight = NULL;
}
