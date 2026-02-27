#!/bin/bash

arch=${1:-arm64-v8a}
data=$(curl -s https://gitlab.com/api/v4/projects/ironfox-oss%2FIronFox/releases | jq -r '.[0]')
apk=$(echo "$data" | jq -r '.assets.links[] | select(.name | endswith("'"-$arch.apk"'")) | .url')
wget -q "$apk" -O latest.apk

wget -q https://github.com/iBotPeaches/Apktool/releases/download/v2.12.0/apktool_2.12.0.jar -O apktool.jar
wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
chmod +x apktool*

rm -rf patched patched_signed.apk
./apktool d latest.apk -o patched
rm -rf patched/META-INF

sed -i 's/<color name="fx_mobile_surface">.*/<color name="fx_mobile_surface">#ff000000<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_background">.*/<color name="fx_mobile_background">#ff000000<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_layer_color_2">.*/<color name="fx_mobile_layer_color_2">@color\/photonDarkGrey90<\/color>/g' patched/res/values-night/colors.xml

# Smali patching
sed -i 's/ff2b2a33/ff000000/g' patched/smali_classes2/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff42414d/ff15141a/g' patched/smali_classes2/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff52525e/ff15141a/g' patched/smali_classes2/mozilla/components/ui/colors/PhotonColors.smali

# Recompile the APK
./apktool b patched -o patched.apk

zipalign 4 patched.apk patched_signed.apk
rm -rf patched patched.apk
