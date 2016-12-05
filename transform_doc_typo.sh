# replace toul>.html with tool.html
# \\\. to produce \. still return warning but works.
fgrep -l toul\>.html *html | awk '{print " sed -i \"s/toul.\\\.html/tool.html/\" " $0 }' > run1612.sh


# replace "toul review..." with "tool review...", omitting the review word, but account for a space
fgrep -l toul\>\  *html | awk '{print " sed -i \"s/toul.\\\ /tool\ /\" " $0 }' > run1612.sh

