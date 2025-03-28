(formerly render_test.md)

# *TEST* rendering of .md

others can ignore this doc.
It is here to test how gitlab (and github) render .md as web pages.


`backtick maybe similar to HTML <TT></TT>?`

URL:
* https://greyhound.lbl.gov/greta/config/-/blob/main/network/vpn/README.rst 
* https://github.com/greta-sw/config/blob/main/network/vpn/README.rst 

- https://greyhound.lbl.gov/greta/config/-/blob/main/network
- https://github.com/greta-sw/config/tree/main/network


link to doc within git repo

* vpn/README.rst 
* `vpn/README.rst`  // quoted with backticks
* `vpn/`            // quoted with backticks


double back ticks:
``sudo openvpn --config client-linux-tin.conf``



# example from Tynan

eg from build/README.md

eg See [file called COMMANDS.md](COMMANDS.md) for full list of ...   // ie square backet text for human to read, round parenthesis is for code of the link/location

so should be able to do:

[human text](network/vpn/README.rst)  // square backet text for human to read, round parenthesis is for code of the link/location.  path should be relative to dir this .md is located, not full path from root of repo.




# reference

https://www.markdownguide.org/basic-syntax/

[github blog relative links in md](https://github.blog/2013-01-31-relative-links-in-markup-files/)


without a continuous seq of [] and ()  -- without spaces, they are just not rendered in any special way and the original text would be visible in final render.  eg:

[github blog relative links in md]  // square backet without following with round parenthesis 

(https://github.blog/2013-01-31-relative-links-in-markup-files/)   // round parenthesis without prefixing with sq bracket -- https url

(network/vpn/README.rst) // round parenthesis without prefixing with sq bracket -- doc link


can relative path with . and .. be inside the doc link syntax?
last time had problem with this:

See [./FAQ-dev-env.rst](./FAQ-dev-env.rst) for FAQ on the GRETA DEV env,

that won't work in here cuz wrong relative path, but does it render ok?
can it work with .. ?  eg:

See [../FAQ-dev-env.rst](../FAQ-dev-env.rst) for FAQ on the GRETA DEV env,

oh , that doc was an rst... it was docroot/config/README.rst  changed it to .md



```
preformated text
eg for code
newline would be treated as hard new line
will not wrap long line 1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890
```


back to normal text here.  don't think there is way to have a hard line break in the normal text, sort of having a blank line in this original text here, which i don't like too much... become too different between source ascii and .md rendered text.

but oh well, i don't get to make the rules, and i ain't going to write my own mark up render language! :P

so actually no, blank line show up too.  
so how do i have hard line break?  I expect this line to be continuous with above.
what?  there is some fuzzy logic to this?  short line does get interpreted as hard line break?
cuz next blonk of long lines with number filler got rendered as single paragraph.
if so, i will abandne .rst for .md, just have to use // for comment :) or :(  not sure yet...


1 another test for long line 1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890
2 another test for long line 1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890
3 another test for long line 1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890

1 another test for long line 1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890.  full stop get parsed as hard line break?  let's end with full stop, not question mark.
2 another test for long line 1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890.
3 another test for long line 1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890.

nope, full stop at end doesn't cut it.  fuzzy logic it seems.

~~~~
four tilde, in issue/ticketing view, seems to start a preformatted block as well.  not sure how to mark the end of it either.  
another test for long line 1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890
line before and after would show up too, so don't have them here if don't want the shaded pre-formatted block to have empty lines
~~~~

text after another four tilde
another test for long line 1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890  1234567890

so 4~ mark begining and end of pre-formatted text.  what about 3~ ?

~~~

block inside 3 tilde
yes, essentially a block, but they have a leading empty line above, but not below...?

~~~


end of block inside 3 tilde.   back to normal?   can treat 3tildes as 3-backticks?


````
so what about 4 backtick?
````


end of 4 backtick, get a feeling this isn't going to show up well, as least not in the vim syntax highlight... 
vim issue only?  gitlab rendered it okay, without extra backtick showing


.. code?  nope, that was a .rst thing.  it is treated as normal text here in md seems like bad vim code below anyway.

.. vim: set tabstop=12
