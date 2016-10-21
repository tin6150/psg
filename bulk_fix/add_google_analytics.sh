for FILE in `ls -1 *.html`; do
	#echo  $FILE
	cat google_tracking_code.txt >> $FILE
done
