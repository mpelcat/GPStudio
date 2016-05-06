#ifndef DOCVIEWER_H
#define DOCVIEWER_H

#include <QWidget>

class DocViewer : public QWidget
{
    Q_OBJECT
public:
    explicit DocViewer(QWidget *parent = 0);

signals:

public slots:
    void loadFileCode(QString file);
};

#endif // DOCVIEWER_H
