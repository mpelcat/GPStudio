#include "codeeditor.h"

#include "syntaxhighlight/vhdlsyntax.h"
#include "syntaxhighlight/xmlsyntax.h"
#include "syntaxhighlight/verilogsyntax.h"
#include "syntaxhighlight/tclsyntax.h"

#include <QDebug>
#include <QFileInfo>
#include <QKeyEvent>
#include <QToolTip>

CodeEditor::CodeEditor(QWidget *parent)
    : QPlainTextEdit(parent)
{
    QFont font = QFont("monospace");
    font.setStyleHint(QFont::TypeWriter);
    setFont(font);
    setTabStopWidth(fontMetrics().width("    "));
    document()->setIndentWidth(fontMetrics().width("    "));
    setLineWrapMode(QPlainTextEdit::NoWrap);
    highlight = NULL;
    connect(this, SIGNAL(cursorPositionChanged()), this, SLOT(highlightCurrentLine()));
    setMouseTracking(true);
}

QString CodeEditor::textUnderMouse(QPoint pos) const
{
    QTextCursor cursorMouse = cursorForPosition(pos);
    QTextCursor wordMouse = cursorMouse;
    wordMouse.movePosition(QTextCursor::StartOfWord, QTextCursor::MoveAnchor);
    wordMouse.movePosition(QTextCursor::EndOfWord, QTextCursor::KeepAnchor);
    return wordMouse.selectedText();
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

void CodeEditor::mouseMoveEvent(QMouseEvent *event)
{
    QPlainTextEdit::mouseMoveEvent(event);
    if(event->modifiers().testFlag(Qt::ControlModifier))
    {
        //qDebug()<<textUnderMouse(event->pos());
    }
}

bool CodeEditor::event(QEvent *event)
{
    if (event->type() == QEvent::ToolTip)
    {
        QHelpEvent *helpEvent = static_cast<QHelpEvent *>(event);

        QToolTip::showText(helpEvent->globalPos(), textUnderMouse(helpEvent->pos()));

        /*QToolTip::hideText();
        event->ignore();*/

        return true;
    }
    return QPlainTextEdit::event(event);
}

void CodeEditor::loadFileCode(QString file)
{
    clear();

    if(highlight)
        highlight->deleteLater();

    QFile fileIO(file);
    if(fileIO.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        setPlainText(fileIO.readAll());
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

void CodeEditor::highlightCurrentLine()
{
    QList<QTextEdit::ExtraSelection> extraSelections;
    QTextEdit::ExtraSelection selection;

    // highlight line
    QColor lineColor = QColor(200,255,255);
    selection.format.setBackground(lineColor);
    selection.format.setProperty(QTextFormat::FullWidthSelection, true);
    selection.cursor = textCursor();
    selection.cursor.clearSelection();
    extraSelections.append(selection);

    // get current word and check if need to highlight
    QTextCursor cursor = textCursor();
    cursor.select(QTextCursor::WordUnderCursor);
    QColor yellowColor = QColor(Qt::yellow).lighter(100);
    QString currentWord = cursor.selectedText();
    if(currentWord.isEmpty())
        currentWord = textCursor().selectedText();
    QRegExp filterWord("[a-zA-Z]+[a-zA-Z0-9\\_]*");

    // highlight words similar to current word
    if(filterWord.indexIn(currentWord)==0)
    {
        QRegExp similarWordsExp("[\\s();,]+("+QRegExp::escape(currentWord)+")[\\s();,\\[]+");

        QString documentText = document()->toPlainText();
        QTextCursor newCursor(document());
        int pos = 0;

        while((pos = similarWordsExp.indexIn(documentText, pos))!=-1)
        {
            newCursor.setPosition(similarWordsExp.pos(1));
            newCursor.movePosition(QTextCursor::NextCharacter, QTextCursor::KeepAnchor, similarWordsExp.cap(1).size());

            selection.format.setBackground(yellowColor);
            selection.cursor = newCursor;
            extraSelections.append(selection);

            pos += similarWordsExp.matchedLength();
        }
    }

    // set highlighted words
    setExtraSelections(extraSelections);
}
