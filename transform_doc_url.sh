# replace dl.dropboxusercontent.com/u/31360775 to tin6150.github.io 
# \\\/ to produce / is probably not necessary, at least not in the awk in MINGW64, but it doesn't hurt
 
#fgrep -l "31360775"  *html | awk '{print " sed -i \"s/dl.dropboxusercontent.com\\\/u\\\/31360775/tin6150.github.io/g\" " $0 }'  > run2016_dropbox.sh

#fgrep -l "31360775"  *html | awk '{print " sed -i \"s/dl.dropbox.com\\\/u\\\/31360775/tin6150.github.io/g\" " $0 }'  > run2016_dropbox.sh

#fgrep -l "dropbox"  *html | awk '{print " sed -i \"s/This new home page at dropbox/This new home page at github/\" " $0 }'  > run2016_dropbox.sh


# unixville.com/~sn/psg to tin6150.s3-website-us-west-1.amazonaws.com
# \~ to produce ~ prob not necessary, but don't hurt
#fgrep -l "unixville.com"  *html | awk '{print " sed -i \"s/unixville.com\\\/\~sn\\\/psg/tin6150.s3-website-us-west-1.amazonaws.com/g\" " $0 }'  > run2016_dropbox.sh


fgrep -l "cs.fiu" *html | awk '{print " sed -i \"s/www.cs.fiu.edu\\\/\~tho01\\\/psg/psg.ask-margo.com/g\" " $0 }'  > run2016_dropbox.sh
