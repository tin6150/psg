

# remove </html> tag that is before the google analytics code, 
# readd it at the end.

for FILE in `ls -1 *.html`; do
	#echo  $FILE
	sed -i 's/<\/html>//' $FILE
	echo '' >> $FILE
	echo '</html>' >> $FILE
done
