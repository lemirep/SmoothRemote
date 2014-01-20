
HEADERS += CoreApplication.h

SOURCES += main.cpp \
           CoreApplication.cpp

RESOURCES += \
    resources.qrc

INCLUDEPATH += $$PWD

include (./Global/Global.pri)
include (./Models/Models.pri)
include (./Audio/Audio.pri)
include (./Video/Video.pri)
include (./Player/Player.pri)
include (./Remote/Remote.pri)
include (./View/View.pri)
include (./DatabaseManagement/DatabaseManagement.pri)
include (./WebServiceManagement/WebServiceManagement.pri)

OTHER_FILES += \
    qml/main.qml \
    qml/SlideMenu.qml \
    qml/MainView.qml \
    qml/RemoteScreen.qml \
    qml/MovieScreen.qml \
    qml/TVShowScreen.qml \
    qml/TopBanner.qml \
    qml/SettingsScreen.qml \
    qml/AudioScreen.qml \
    qml/TextInputComponent.qml \
    qml/DynamicGridView.qml \
    qml/CoverImage.qml \
    qml/VideoCoverDelegate.qml \
    qml/ScrollBar.qml \
    qml/MediaDetailScreen.qml \
    qml/TVShowDetail.qml \
    qml/MovieDetail.qml \
    qml/PlayTargetPopup.qml \
    qml/Player.qml \
    android/AndroidManifest.xml \
    qml/LoadIndicator.qml \
    qml/Resources/player_fbackward.png \
    qml/Resources/small_play.png \
    qml/Resources/player_forward.png \
    qml/Resources/player_play.png \
    qml/Resources/player_stop.png \
    qml/Resources/player_fforward.png \
    qml/Resources/empty_cd.png \
    qml/Resources/download_arrow.png \
    qml/Resources/player_backward.png \
    qml/Resources/arrow.png \
    qml/Resources/player_pause.png \
    databaseThread.o \
    qml/ArtistAlbumsScreen.qml \
    qml/CoverFlow.qml \
    qml/AlbumSongsScreen.qml \
    qml/ActionBar.qml \
    qml/SlideMenuDelegate.qml \
    qml/Resources/arrow_down.png \
    qml/Resources/at.png \
    qml/Resources/back_arrow.png \
    qml/Resources/camera.png \
    qml/Resources/check.png \
    qml/Resources/close.png \
    qml/Resources/cloud.png \
    qml/Resources/cog.png \
    qml/Resources/denied.png \
    qml/Resources/download.png \
    qml/Resources/equalizer.png \
    qml/Resources/fork.png \
    qml/Resources/headphones.png \
    qml/Resources/last.png \
    qml/Resources/magnifying_glass.png \
    qml/Resources/move2.png \
    qml/Resources/movie.png \
    qml/Resources/play.png \
    qml/Resources/sync.png \
    qml/Resources/view.png \
    qml/Resources/volume_mute.png \
    qml/Resources/volume.png \
    qml/Resources/info.png \
    qml/PlaylistsScreen.qml \
    qml/RemoteControls.qml


ANDROID_TARGET_ARCH = armeabi-v7a
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

qnx {
    PACKAGE_ARGS = \
        $${PWD}/bar-descriptor.xml $$TARGET \
        -e $$[QT_INSTALL_LIBS]/libQt5Core.so.5 lib/libQt5Core.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Gui.so.5 lib/libQt5Gui.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5OpenGL.so.5 lib/libQt5OpenGL.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Network.so.5 lib/libQt5Network.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Quick.so.5 lib/libQt5Quick.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Qml.so.5 lib/libQt5Qml.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Sql.so.5 lib/libQt5Sql.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Multimedia.so.5 lib/libQt5Multimedia.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5V8.so.5 lib/libQt5V8.so.5 \
        -e $$[QT_INSTALL_PLUGINS]/platforms/libqqnx.so plugins/platforms/libqqnx.so \
        -e $$[QT_INSTALL_PLUGINS]/imageformats/libqjpeg.so plugins/imageformats/libqjpeg.so \
        -e $$[QT_INSTALL_QML]/ qml/

    package.target = $${TARGET}.bar
    package.depends = $$TARGET
    package.commands = blackberry-nativepackager \
        -package $${TARGET}.bar \
        -devMode -debugToken $$(DEBUG_TOKEN) \
        $${PACKAGE_ARGS}

    QMAKE_EXTRA_TARGETS += package

    OTHER_FILES += bar-descriptor.xml
}

