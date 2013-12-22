#include <QtGui/QGuiApplication>
#include "ViewManagement.h"
#include "CoreApplication.h"
#include <QDebug>

int main(int argc, char *argv[])
{
    qDebug() << 1;
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));
    qDebug() << 2;


    QCoreApplication::setOrganizationName("Paul Lemire");
    QCoreApplication::setApplicationName("Smooth Remote");
    qDebug() << 3;

    QScopedPointer<ViewManagement> viewManager(ViewManagement::getInstance());
    qDebug() << 4;
    QScopedPointer<CoreApplication> coreApplication(CoreApplication::getInstance());
    qDebug() << 5;

    viewManager->setSource(QUrl("qrc:/qml/main.qml"));
    qDebug() << 6;
    viewManager->getContext()->setContextProperty("core", coreApplication.data());
    qDebug() << 7;
    viewManager->show();
    qDebug() << 8;

    return app->exec();
}
