# replace toul>.html with tool.html
# \\\. to produce \. still return warning but works.
# fgrep -l toul\>.html *html | awk '{print " sed -i \"s/toul.\\\.html/tool.html/\" " $0 }' > generated_run1612.sh


# replace "toul review..." with "tool review...", omitting the review word, but account for a space
# fgrep -l toul\>\  *html | awk '{print " sed -i \"s/toul.\\\ /tool\ /\" " $0 }' > generated_run1612.sh


## replace php.html with php.txt
## get commmands like:
## sed -i "s/php.html/php.txt/" aws.html
#fgrep -l php.html *html | awk  '{print " sed -i \"s/php.html/php.txt/\" " $0 }' > generated_fixtypo.sh


## replace "ting" <BR>   with hoti1<BR>
## get commmands like:
## sed -i "s/\"ting\" <BR>/hoti1<BR>/" vnc.html
# fgrep -l '"ting" <BR>' *html | awk '{print " sed -i \"s/\\\"ting\\\" <BR>/hoti1<BR>/\" " $0 }' > generated_fixtypo.sh


## replace "ting"<BR>   with tin5050<BR>
## no space after "ting"
## get commmands like:
# fgrep -l '"ting"<BR>' *html | awk '{print " sed -i \"s/\\\"ting\\\"<BR>/sn5050<BR>/\" " $0 }' > generated_fixtypo.sh



## replace "ting"</div>   with bofh</div>
## get commmands like:
##  sed -i "s/\"ting\"<\/div>/bofh1<\/div>/" vnc.html
#fgrep -l '"ting"</div>' *html | awk '{print " sed -i \"s/\\\"ting\\\"<\\/div>/bofh1<\\/div>/\" " $0 }' > generated_fixtypo.sh

