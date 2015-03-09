#ifndef SCRIPTWIDGET_H
#define SCRIPTWIDGET_H

#include "gpstudio_gui_common.h"

#include <QWidget>

#include <QLineEdit>
#include <QPlainTextEdit>
#include <QPushButton>

#include <QScriptEngine>

#include "scriptlineedit.h"

class GPSTUDIO_GUI_EXPORT ScriptWidget : public QWidget
{
    Q_OBJECT
public:
    explicit ScriptWidget(QWidget *parent = 0);
    virtual ~ScriptWidget();

    QScriptEngine *engine() const;
    void setEngine(QScriptEngine *engine);

signals:

public slots:
    void exec();

private slots:
    void up();
    void down();

private:
    QScriptEngine *_engine;
    QPlainTextEdit *_textEdit;
    ScriptLineEdit *_lineEdit;
    QPushButton *_execButton;

    QStringList _histo;
    int _histoIndex;
};

#endif // SCRIPTWIDGET_H
