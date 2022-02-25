psg
===

This is git repo for content in http://psg.skinforum.org/

Also build to https://tin6150.github.io/psg 

Scripts are placed in the script subdir, eg  https://github.com/tin6150/psg/tree/master/script

-------------------------------------------


## Some basic git commands
``` bash

##git config --global user.email "tin6150@gmail.com"
git config --global user.email "tin@cueball"		# change this to machine specific settings to get better idea of where commits, 
							# merges are done, but don't display well on bitbucket :(
git config --global user.name tin6150
## in bitbucket, need username to match what bitbucket.org has in record for it to prompt for pwd
git config --global credential.helper 'cache --timeout=36000'
git config --global github.user   tin6150
git config --global alias.lol "log --oneline --graph --decorate"		# create alias "git lol"   # logd

git config merge.conflictstyle diff3		# cmd diff tool, make file w/ <<<< |||| >>>>, bearable


git clone https://github.com/tin6150/psg.git

git init

git add *
git commit -m "first commit"
# still need to pre-create the repo in github before push can take place 
# git remote add origin https://github.com/tin6150/psg.git
git push -u origin master


# above code block was delimited by ``` bash  (optional language for syntax highlight)
# ends with ``` in a line by itself
```




------------------------------------------------------------
# Playing with markdown...

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.md  ext is for MarkDown format -- see wiki.html#markdown
.rst ext is for ReStructured Text, which I like more than .md
for eg of .rst, see https://github.com/tin6150/psg/blob/master/reStructuredText_markup.rst
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


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
// well, change to use // or ; as comment in md? :P

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


# Rmd only

// see stat 142 Lab 04 for detail
$P(+ \mid D)$   
renders as P(+|D)
the dollar sign delimiter some rendering.  Tex?  Rstudio, hoover them will render the human friendly "graphics"
\mid is midbar?  it is the pipe symbol.

