reStrcutured Text
*****************

Does github support this markup?  it did for NeRSC Shifter... 
But I need to enable such support in my own repo for it to render?
No, just needed to remove the .md text that was in the bottom
it somehow confused the parser and so didn't render it at all.
now that there is no markdown format text, .rst renders well
(though not which of markdown text threw off the parser)

RST 
===

Planning to swtich to reStructured Text and avoid MarkDown.

.rst is adopted in python.  
As python, space matter.  But this is the case of nested list, which in this case, probably can't get away from it in a simple plain text format.

Given the tech nature of most doc, .rst probably better than markdown.
However, stackoverflow is essentially markdown.


Examples that works
-------------------


- use dash to start list
- use underline_ at end_ to create list_  # but need more details 
- ```triple backquotes```  highligt in reverse text and monospace font
- single *asterist* around *word*or*words* is italic. *asterisk text can have space*.  
- and **double asterisks** became bold
- nice thing is vim will highlight text specially from .rst syntax (mostly)


List with hash

#) a numbered list
#) another entry
#) third entry

Nested list.  use dash.  Let .rst render deal with numbering.  using numbers, letters, hash just confuses it.


- starting a list
- continue list 
- continue list 
- continue list 
- continue list .... and when it is about to start a sub list, this line becomes bold italic
    - four spaces
    - four spaces
- continue list
- continue list 
	- one tab here
	- one tab here
	- one tab here
		- two tabs here for sub-sub list
		- two tabs here for sub-sub list
		- two tabs here for sub-sub list


Examples, but many don't work correctly.  they were my learning experience.
-----------


#   comment this should not be special emphasis in .rst, as did .md
##  double hash should also not be special.
#   but this comment "block" was runned into continuous line rather than hard ended line

# what if i start a new block
# of comment
# with many lines
# and no double hash in the middle

## this is double hash line 
## block 
## of text

### the issue is that .rst does not treat newline in ascii 
### as new line in rendered text
### which is expected behavior for flowing text
### only blank line that break paragraph becomes new line

So, just like normal text <BR>
Use html markdup of "br" <BR>
to mean hard break of line?
Nope.  RTFM!



I wonder the stuff that SLACK use, how is it in .rst?

Example nested list with dash
----------------------

- `backquote`      
- `backquote`       # don't seems to be rendered any differently, even though vim did highlight it
- 'single quote'
- 'single quote'	# again, everything is verbatim here
- "double quote"	# this was rendered in italic in github
    - a four-space indented list item
- lets try with triples:
    * ```triple backquotes```  yes this was highligted in reverse text and monospace font
    * '''triple single quote'''
    * """triple double quote"""
* bulleted list same as dash list?
* hope so
  * yes, but sublist may need 4 spaces and not 2.
  * like here

Text highlight (and bullet list with indent but no blank lines)
  * single *asterist* around *word*or*words* is italic.  no, *asterisk text can have space*.  
  * what about **double asterisks** became bold
  * but ***triple asterisks*** means nothing special
  * _single underline_ .  seems like word_ ending_ with_ underline_ becomes_ links_
  * __double underlines works?__
  * _need_underline_in_space_too
  * squiqle ~squigle~
  * nice thing is vim will highlight text specially from .rst syntax (mostly)


List with hash

#) a numbered list
#) another entry
#) third entry

Nested list.  use dash.  Let .rst render deal with numbering.  using numbers, letters, hash just confuses it.

- starting a list
- continue list
    - four spaces
    - four spaces
- continue list
- continue list
- continue list
	- one tab
	- one tab
- continue list
- continue list
	- tab vs space don't matter
	- tab vs space has no diff
		- sub-sub list
		- sub-sub list


------------------------------

bunch of ---- in a line by itself treated by .md as horizontal line, same in .rst?  --> Yes


----------------------

- To start list, do not start with space
- Adding space in the beginning will be treated as quoted text and add email-style indent/quote vertical bar in front of it
    - Sublist need to be started with 4 space, or else this special block treated as quote text
    - removed old README.md file 
	- maybe that was causing confusion
	- so now it would render by github?
    - TBA...
    - Tired of numbering list myself, using hash sign in this line.
        - sub-sub line of hash
        - another sub line of hash




can't use numbers and letters for nested list.  below don't render correctly :(  
probably nothing to do with space vs tab

A. To start list, do not start with space
A. Adding space in the beginning will be treated as quoted text and add email-style indent/quote vertical bar in front of it
    1. Sublist need to be started with 4 space, or else this special block treated as quote text
    1. removed old README.md file 
	a) maybe that was causing confusion
	b) so now it would render by github?
    1. TBA...
    1. Tired of numbering list myself, using hash sign in this line.
        #) sub-sub line of hash
        #) another sub line of hash
    1. Instead of hash, can repeat number?
	a) and use '''a)''' repeatedly too?
	a) and use '''a)''' repeatedly too?
	a) and use '''a)''' repeatedly too?


Nested list is difficult, and there is diff b/w tab and spaces. nope!!

1. starting a list
2. continue list
    a. four spaces
    a. four spaces
3. continue list
4. continue list
	a. one tab
	a. one tab
5. continue list

=======

This number block below starts with indented space.

  1. To start list, do not start with space
  1. Adding space in the beginning will be treated as quoted text and add email-style indent/quote vertical bar in front of it
  1. removed old README.md file 
    a) maybe that was causing confusion
    b) so now it would render by github?
  2. TBA...
  #. Tired of numbering list myself, using hash sign in this line.
    #) sub line of hash
    #) another sub line of hash

----------------------

This block with 2 space treated as quoted text

A. To start list, do not start with space
B. Adding space in the beginning will be treated as quoted text and add email-style indent/quote vertical bar in front of it
  1. removed old README.md file 
    a) maybe that was causing confusion
    b) so now it would render by github?
  2. TBA...
    #. Tired of numbering list myself, using hash sign in this line.




--------------------------------
--------------------------------
this isn't example of boxed text
--------------------------------
--------------------------------
