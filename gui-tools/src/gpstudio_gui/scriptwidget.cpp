#include "scriptwidget.h"

#include <QDebug>
#include <QBoxLayout>

#include <QScriptEngine>

ScriptWidget::ScriptWidget(QWidget *parent) :
    QWidget(parent)
{
    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    _textEdit = new QPlainTextEdit();
    _textEdit->setReadOnly(true);
    layout->addWidget(_textEdit);

    QLayout *layout2 = new QHBoxLayout();
    layout2->setContentsMargins(0,0,0,0);
    layout2->setSpacing(6);
    _lineEdit = new ScriptLineEdit();
    connect(_lineEdit, SIGNAL(returnPressed()), this, SLOT(exec()));
    connect(_lineEdit, SIGNAL(up()), this, SLOT(up()));
    connect(_lineEdit, SIGNAL(down()), this, SLOT(down()));
    layout2->addWidget(_lineEdit);

    _execButton = new QPushButton("exec");
    connect(_execButton, SIGNAL(clicked()), this, SLOT(exec()));
    layout2->addWidget(_execButton);

    layout->addItem(layout2);
    setLayout(layout);

    _histoIndex = -1;
}

ScriptWidget::~ScriptWidget()
{
}

void ScriptWidget::exec()
{
    _textEdit->appendPlainText("> "+_lineEdit->text());
    QScriptValue value = ScriptEngine::getEngine().eval(_lineEdit->text());
    if(value.isError())
    {
        _textEdit->appendHtml("<pre style=\"color:red\">"+value.toString()/*.toHtmlEscaped()*/+"</pre>");
    }
    else
    {
        _textEdit->appendPlainText(value.toString());
    }

    _histo.append(_lineEdit->text());
    _lineEdit->clear();
    _histoIndex = _histo.count();
}

void ScriptWidget::up()
{
    if(_histoIndex<=0) return;
    _histoIndex--;
    _lineEdit->setText(_histo[_histoIndex]);
}

void ScriptWidget::down()
{
    if(_histoIndex > 0 && _histoIndex>=_histo.count()-1) return;
    _histoIndex++;
    _lineEdit->setText(_histo[_histoIndex]);
}
