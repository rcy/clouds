update: clean update.images count

v:
	sqlite3 images.db

images.db:
	sqlite3 $@ "create table images (id text primary key, filename text unique, timestamp text, brightness number);"

count:
	sqlite3 images.db 'select count(*) from images;'

images.txt:
	find /mnt/storage/webcam/images -name 2*.png > $@

images.csv: images.txt
	echo id,filename,timestamp > $@
	awk -F/ '{ printf "%s,%s,%s-%s-%s %s:%s:00\n", $$NF, $$0, substr($$NF,0,4), substr($$NF,5,2), substr($$NF,7,2), substr($$NF,10,2), substr($$NF,12,2) }' $< >> $@

insert.%: %.db %.csv
	pipenv run sqlite-utils insert $*.db $* $*.csv --csv

update.%: %.db %.csv
	pipenv run sqlite-utils upsert $*.db $* $*.csv --csv --pk=id --silent

brightness:
	bash update-brightness.sh

clean:
	rm -f *.csv *.txt

drop:
	rm -f *.db

distclean: clean drop
