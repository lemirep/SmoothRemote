#ifndef __VIEWMANAGEMENT_H_
#define __VIEWMANAGEMENT_H_

#include <QObject>
#include <QQuickView>
#include <QQmlContext>

class ViewManagement : public QObject
{
    Q_OBJECT
public:
    static ViewManagement* getInstance();
    ~ViewManagement();

    void    setSource(const QUrl &source);
    QUrl    getSource() const;

    QQmlContext *getContext() const;

    void    show();
    void    showMaximized();
    void    showFullScreen();

private:
    ViewManagement(QObject *parent = NULL);
    ViewManagement(const QUrl &source, QObject *parent = NULL);

private:
    QUrl source;
    QQuickView *viewer;
    QQmlContext *context;
    static ViewManagement *instance;
};


#endif // __VIEWMANAGEMENT_H_
