#include "ViewManagement.h"

ViewManagement* ViewManagement::instance = NULL;

ViewManagement::ViewManagement(QObject *parent) : QObject(parent),
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
    if (this->source != source)
    {
        this->source = source;
        this->viewer->setSource(this->source);
    }
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
