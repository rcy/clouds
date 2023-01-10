#!/bin/bash

while [ $(sqlite3 images.db "select count(*) from images where brightness is null limit 1") != 0 ]; do
    for filename in $(sqlite3 images.db 'select filename from images where brightness is null limit 100'); do
        brightness=$(identify -format "%[fx:mean]\n" $filename)
        sqlite3 images.db "update images set brightness = $brightness where filename = '$filename'"
        echo $filename $brightness
    done
    date
done
