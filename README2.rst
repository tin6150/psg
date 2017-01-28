reStrcutured Text
*****************

Does github support this markup?  it did for NeRSC Shifter... 
But I need to enable such support in my own repo for it to render?

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

Example list with dash
----------------------

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

  1. removed old README.md file 
    a) maybe that was causing confusion
    b) so now it would render by github?
  2. TBA...
  #. Tired of numbering list myself, using hash sign in this line.
    #) sub line of hash
    #) another sub line of hash




