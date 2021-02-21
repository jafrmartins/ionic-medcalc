#!/bin/bash

# EDIT config.xml version
# always use same release key or playstore wil not recognise app update
VERSION="0.0.2"
cordova plugin rm cordova-plugin-console
cordova build --release android
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore /home/anon/Code/ionic-netmedicis/platforms/android/build/outputs/apk/android-release-unsigned.apk alias_name
zipalign -v 4 /home/anon/Code/ionic-netmedicis/platforms/android/build/outputs/apk/android-release-unsigned.apk "netmedicis-v.1.0.1.apk"
