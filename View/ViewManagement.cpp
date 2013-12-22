#include "ViewManagement.h"
#include <QDebug>

ViewManagement* ViewManagement::instance = NULL;

ViewManagement::ViewManagement(QObject *parent) : QObject(parent),
    source(QUrl()),
    viewer(new QQuickView()),
    context(this->viewer->rootContext())
{

}

ViewManagement::ViewManagement(const QUrl &source, QObject *parent) : QObject(parent),
    source(source),
    viewer(new QQuickView()),
    context(this->viewer->rootContext())
{

}

ViewManagement *ViewManagement::getInstance()
{
    if (ViewManagement::instance == NULL)
        ViewManagement::instance = new ViewManagement();
    return ViewManagement::instance;
}

ViewManagement::~ViewManagement()
{
    delete this->viewer;
}


void ViewManagement::setSource(const QUrl &source)
{
    qDebug() << "-1";
    if (this->source != source)
    {
        qDebug() << "-2";
        this->source = source;
        qDebug() << "-3";
        this->viewer->setSource(this->source);
    }
    qDebug() << "-4";
}


QUrl ViewManagement::getSource() const
{
    return this->source;
}

QQmlContext *ViewManagement::getContext() const
{
    return this->context;
}

void ViewManagement::show()
{
    this->viewer->show();
}

void ViewManagement::showMaximized()
{
    this->viewer->showMaximized();
}

void ViewManagement::showFullScreen()
{
    this->viewer->showFullScreen();
}
