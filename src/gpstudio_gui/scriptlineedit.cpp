#include "scriptlineedit.h"

#include <QKeyEvent>

ScriptLineEdit::ScriptLineEdit(QWidget *parent) :
    QLineEdit(parent)
{
}

ScriptLineEdit::~ScriptLineEdit()
{
}

void ScriptLineEdit::keyPressEvent(QKeyEvent *event)
{
    if(event->key() == Qt::Key_Up) emit up();
    if(event->key() == Qt::Key_Down) emit down();
    QLineEdit::keyPressEvent(event);
}
