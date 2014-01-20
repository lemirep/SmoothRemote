#include <QtGui/QGuiApplication>
#include "ViewManagement.h"
#include "CoreApplication.h"
#include <QDebug>
#include <QtQml>

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));

    QCoreApplication::setOrganizationName("Paul Lemire");
    QCoreApplication::setApplicationName("Smooth Remote");

    QScopedPointer<CoreApplication> coreApplication(CoreApplication::getInstance());

    ViewManagement *viewManager = ViewManagement::getInstance();

    viewManager->setSource(QUrl("qrc:/qml/main.qml"));
    viewManager->getContext()->setContextProperty("core", coreApplication.data());
#ifdef Q_WS_ANDROID
    viewManager->showFullScreen();
#else
    viewManager->show();
#endif
    return app->exec();
}
