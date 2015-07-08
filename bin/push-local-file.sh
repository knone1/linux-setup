#!/bin/sh -e

TMP=/sdcard/push

dir="$1"
shift
full_file="$1"
shift

if [ "$1" = "" ]; then
   perms=644
else
   perms=$1
fi

file=`basename $full_file`
echo "Pushing: $dir/$file"
adb shell mkdir -p $TMP
adb push "$full_file" $TMP/$file
adb shell su -c "mount -o remount,rw /system"
adb shell su -c "mv $dir/$file $dir/$file.old"
adb shell su -c "cp '$TMP/$file' '$dir/'"
adb shell su -c "chmod $perms $dir/$file"
adb shell su -c "restorecon -v $dir/$file"
adb shell su -c "mount -o remount,ro /system"
