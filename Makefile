YEAR:=$(shell date +%Y)
MONTH:=$(shell date +%m)
DAY:=$(shell date +%d)
TODAY:=${YEAR}/${MONTH}/${DAY}
BASE_DIR:=/mnt/storage/webcam/images
TODAY_DIR:=${BASE_DIR}/${TODAY}

all:
	${MAKE} alldays.${MAKE}
	${MAKE} sync

alldays.%:
	find ${BASE_DIR} -mindepth 3 -name *-2359.png | cut -d/ -f6-8 | sed -E s.^.videos/. | sed -E s/\$$/.mp4/ | xargs $*

videos/%.mp4:
	mkdir -p $$(dirname $@)
	rm -f $@
	cat $$(find ${BASE_DIR}/$* -type f | sort -V) | ffmpeg -r 25 -i - -vcodec libx264 -crf 22 $@

sync:
	rsync -av ./videos /mnt/storage/webcam
