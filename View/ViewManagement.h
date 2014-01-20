#ifndef __VIEWMANAGEMENT_H_
#define __VIEWMANAGEMENT_H_

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>

class ViewManagement : public QObject
{
    Q_OBJECT
public:
    static ViewManagement* getInstance();
    ~ViewManagement();

    void    setSource(const QUrl &source);
    QUrl    getSource() const;

    QQmlContext *getContext() const;
    QQuickWindow *getWindow() const;

    void    show();
    void    showFullScreen();
    void    showMaximized();

private:
    ViewManagement(QObject *parent = NULL);
    ViewManagement(const QUrl &source, QObject *parent = NULL);

private:
    QUrl source;
    QQmlApplicationEngine *appEngine;
    QQmlContext *context;
    QQuickWindow *window;
    static ViewManagement *instance;

};


#endif // __VIEWMANAGEMENT_H_
