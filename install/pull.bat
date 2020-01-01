@ECHO OFF
CALL config.bat
docker pull %CRI_IMAGES_PAUSE%
docker pull %CRI_IMAGES_NANOSERVER%
docker pull %CRI_IMAGES_SERVERCORE%
