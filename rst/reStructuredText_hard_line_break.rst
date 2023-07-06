
There is no reasonable way to do hard line break in .rst  \

\ at end is ignored by rst (in github anyway), it just escape an actual new line.  no use for .rst
this hack said to work in .md


hard new line in rst need to be prefixed in an annoying way.

| the pipe in the beginning indicate where line breaks are
| another line

another trick was to use raw HTML, but that's for web rendering only.  see
https://stackoverflow.com/questions/51198270/how-do-i-create-a-new-line-with-restructuredtext/51199504

.md allow use of \
at end for hard line break
or the double space at end, which works, except it is invisible and some text editor automatically stripe end white space.

.. .md two tailing white spaces cannot cause a hard line break  
.. nor can \ 
.. i wondered about: \^M at the end, but that didnt work either



old notes
=========

### the issue is that .rst does not treat newline in ascii
### as new line in rendered text
### which is expected behavior for flowing text
### only blank line that break paragraph becomes new line

So, just like normal text <BR>
Use html markdup of "br" <BR>
to mean hard break of line?
Nope.  RTFM!

