
RST 
===

Planning to swtich to reStructured Text and avoid MarkDown.

.rst is adopted in python.  
As python, space matter.  But this is the case of nested list, which in this case, probably can't get away from it in a simple plain text format.

Given the tech nature of most doc, .rst probably better than markdown.
However, stackoverflow is essentially markdown.

#   comment this should not be special emphasis in .rst, as did .md
##  double hash should also not be special.


I wonder the stuff that SLACK use, how is it in .rst?

- `backquote` 
- 'single quote'
- "double quote"
    - a four-space indented list item


#) a numbered list
#) another entry
#) third entry



------------------------------

bunch of ---- in a line by itself treated by .md as horizontal line, same in .rst?

lines below are from the original README.md file
they may render funny in .rst...

----------------------





psg
===

This is git repo for content in http://psg.skinforum.org/

Also build to https://tin6150.github.io/psg 

-------------------------------------------


## Some basic git commands
``` bash

git config --global user.email "tin6150@gmail.com"
git config --global user.name tin6150
## in bitbucket, need username to match what bitbucket.org has in record for it to prompt for pwd
git config --global credential.helper 'cache --timeout=3600'
git config --global github.user   tin6150

git clone https://github.com/tin6150/psg.git

git init

git add *
git commit -m "first commit"
# git remote add origin https://github.com/tin6150/psg.git
git push -u origin master

# above code block was delimited by ``` bash  (optional language for syntax highlight)
# ends with ``` in a line by itself
```

------------------------------------------------------------
# Playing with markdown...

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.md ext is for MarkDown format -- see wiki.html#markdown
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


~~~~
use of 4 ~ to mark
a code block
that spans many lines
~~~~

        tab indent will be a code block
        tabbed again

    four spaces is a code block
    another four spaces
    maybe these are for bitbucket only?



## the comment sign is a heading marker in markdown.
###this is my biggest gripe about .md !!
I want to de-emphasize lines marked as # comment, not emphasize them!
Thus, places where i want to use # as comment, has to delineate it as a code block

**bold are two asterisks**
__or two underlines, but remember no spaces after the symbols__

*single asterisks for italic* 
_or single underscore_

___triple underscore or asterisks for both italic and bold___


a regular line here
no way to make text underlined?!  as web assume that's a link??!! 


stackoverflow pretty much use all the markdown syntax (except for code highlight block).
and its summary is more concise than the markdown project doc.
See: http://stackoverflow.com/editing-help


