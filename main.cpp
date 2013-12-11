#include <QtGui/QGuiApplication>
#include "ViewManagement.h"
#include "CoreApplication.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));

    QCoreApplication::setOrganizationName("Paul Lemire");
    QCoreApplication::setApplicationName("Smooth Remote");

    QScopedPointer<ViewManagement> viewManager(ViewManagement::getInstance());
    QScopedPointer<CoreApplication> coreApplication(CoreApplication::getInstance());


    viewManager->setSource(QUrl("qrc:/qml/main.qml"));
    viewManager->getContext()->setContextProperty("core", coreApplication.data());
    viewManager->show();

    return app->exec();
}
