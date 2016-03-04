#include "scriptlineedit.h"

#include <QKeyEvent>

#include "scriptengine.h"

#include <camera/camera.h>

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

    QStringList list;

    foreach (Property *property, ScriptEngine::getEngine().rootProperty()->subProperties())
    {
        list << property->name();
    }

    _completer = new QCompleter(list);
    setCompleter(_completer);

    QLineEdit::keyPressEvent(event);
}
