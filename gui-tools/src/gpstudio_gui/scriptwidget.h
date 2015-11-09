#ifndef SCRIPTWIDGET_H
#define SCRIPTWIDGET_H

#include "gpstudio_gui_common.h"

#include <QWidget>

#include <QLineEdit>
#include <QPlainTextEdit>
#include <QPushButton>

#include "scriptlineedit.h"
#include "scriptengine.h"

class GPSTUDIO_GUI_EXPORT ScriptWidget : public QWidget
{
    Q_OBJECT
public:
    explicit ScriptWidget(QWidget *parent = 0);
    virtual ~ScriptWidget();

    ScriptEngine *engine() const;
    void setEngine(ScriptEngine *engine);

signals:

public slots:
    void exec();

private slots:
    void up();
    void down();

private:
    ScriptEngine *_engine;
    QPlainTextEdit *_textEdit;
    ScriptLineEdit *_lineEdit;
    QPushButton *_execButton;

    QStringList _histo;
    int _histoIndex;
};

#endif // SCRIPTWIDGET_H
