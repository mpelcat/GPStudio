#ifndef SCRIPTLINEEDIT_H
#define SCRIPTLINEEDIT_H

#include "gpstudio_gui_common.h"

#include <QLineEdit>

class GPSTUDIO_GUI_EXPORT ScriptLineEdit : public QLineEdit
{
    Q_OBJECT
public:
    explicit ScriptLineEdit(QWidget *parent = 0);
    virtual ~ScriptLineEdit();

signals:
    void up();
    void down();

protected:
    void keyPressEvent(QKeyEvent *event);

public slots:

};

#endif // SCRIPTLINEEDIT_H
