#!/bin/sh
# dwb: gd
# youtube.com
if echo $1 | grep -q "^http://www.youtube.com/watch?" || echo $1 | grep -q "^https://www.youtube.com/watch?"
then
	(cd /dev/shm/ && uxterm -e "cclive --format=best \"$1\"")
	#echo "download $(youtube-dl -g $1)"
	#echo "download $(youtube-dl -g $1)" > ${DWB_FIFO}
fi
