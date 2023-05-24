reStrcuturedText
****************

github support .rst just as well as .md
Can use README.rst as default rather than README.md.

Any incorrect construct that paralize the .rst parser will stop the rendering and revert back to raw.
Thus, pay special attention to ``code block``  (really ``verbose text, or monospaced text``)
(actually, tailing underline after word seems to be the culprit)

If this page has no error, it renders in github web view (both under PSG and inet-dev-class, which is why consolidated as primary in psg
as the README.md in psg is also useful)

SUMMARY
=======

* use lots of bullet text.  since no reasonable way to make hard  line break in rst.

* keep it simple.  not worth spending time on fancy features.

* use :: (two colons, blank line before and after) for creating pre-formatted text
  since quite often i still just want to preserve my text blocks, new lines.
  Actually, not sure if the color highlight in vim for rst is really worth the headache of creating them.
  a WYSIWYG editor for rst would be nice :)

* use comment (..) for vim modeline, see bottom of this file.  this may really be a hack of rst command?

- use dash to start list
- ``double backquotes``  highligt in reverse text and monospace font
- *single asterist* to delimited *italic text* 
- **double asterisks** became **bold**
- nice thing is vim will highlight text specially from .rst syntax (mostly)


Files location
==============

location of .rst and .md files are in 2 places so that I can see how it got rendered
  - psg/rst/reStructuredText_markup.rst  [*master*]
  - https://github.com/tin6150/inet-dev-class/rst_md/cahce_of_psg_rst/ [cache]

*PSG version will be master*.  inet-dev-class is a cache (and not really needed, as error in rst will cause github not to render in both places, so just need to fix the error!).  


Example of .rst that I maintain to look for constructs
======================================================

ones that I think has features I wondered how they would work out...

* https://github.com/tin6150/inet-dev-class/tree/master/mapbox/README.rst
    - this was pretty extensive, one of the longer .rst that I tried to make for good reading.  
    - tagging for json5 code block
    - image

* https://github.com/tin6150/covid19_care_capacity_map 
   - glossary term, really just to force indent block of text.  messy, no way to do hard line break, so easier to just use lots of nested bullet lists
   - comment, vim: modeline
   
* CF_BK/cueball/ANSIBLE/README.rst 
   - meta tags like :url: 
   - rest of it likely not good render 

* the set of reStructuredText*rst files in this PSG dir for various trial ground


References
----------

- wikipedia on .rst: https://en.wikipedia.org/wiki/ReStructuredText#Examples_of_reST_markup
- reStructuredText quick ref: http://docutils.sourceforge.net/docs/user/rst/quickref.html
- reStructuredText primer: http://docutils.sourceforge.net/docs/user/rst/quickstart.html
- preformatting samples, but not necessarily code syntax highlight: http://docutils.sourceforge.net/docs/user/rst/quickstart.html#preformatting-code-samples 
- pip install rstcheck ; rstcheck file.rst





.. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





Lots of old notes below, TL; DR
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


**todo** 
break multiple sections/examples into different rst files.


GitHub warning
--------------

Look at 
https://github.com/tin6150/inet-dev-class/tree/7fd93429644bebc3c7a5ab059c1bea8d7a3c372a/ansible
the use of == as underline for section heading broke the github parser
and it just turned the doc as ascii text.
There is no "compile error" to find out what could have broken it :(

RST header example probably breaks github rst parser/rendered...


RST 
===

RST quick reference that I like:
https://docutils.sourceforge.io/docs/user/rst/quickref.html#tables

Sphinx is the python doc generator, it is RST based, but also add extensions, so not all sphynx construct works
for git* rendered web pages.




Planning to swtich to reStructured Text and avoid MarkDown.

.rst is adopted in python.  
As python, space matter.  But this is the case of nested list, which in this case, probably can't get away from it in a simple plain text format.

Given the tech nature of most doc, .rst probably better than markdown.
However, stackoverflow is essentially markdown.
github default to .md, and most folks seems to use .md rather than .rst.
.md seems to be better with code block, but i can't stand # rendering as title, as i use that often as comment, even in text files!
hmm... maybe use // as comment, as JavaScript and GOlang do...


Next should be a table of content.  the ``contents directive`` will read entries from the ``topic directive`` , as well as things that parsed are headers (those with underlines and stuff).  Thus, explicit ``topic`` or ``title`` directives are not really necessary.   (``sidebar directive`` not supported by github rendered)
(the topic wasn't listed in contents:: , but the heading line was listed instead.  so, may have no use for ``topic``)


dot_dot is command for rst parser.


Inter-Document link
see:
https://stackoverflow.com/questions/37553750/how-can-i-link-reference-another-rest-file-in-the-documentation
or
https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html#cross-referencing-arbitrary-locations

External URL is actually easy.  no markup is needed if just show whole link.
There are other ways to add ref so whole ugly URL doesn't show up.  RTFM, but not hard.  

But link to just another rst file within the same site, (so that say git backed doc can be rendered in multiple sites), seems rather difficult.
at least i have not really figured out yet :-/ 

Does this inter-document link work? 

sphynx_link: reStructuredText_sphynx.rst

:ref:`sphynx_link` 

(dash in front of sphynx_link may have broke the rst parser and github rendered this page as just plain code)

or this method with just path:

:doc:`./reStructuredText_sphynx.rst` : another rst, small, warning about sphynx extension

or this with name and angle bracket

:doc:`sphynx rst <./reStructuredText_sphynx.rst>`

or this  with angle bracket

:doc:`<./reStructuredText_sphynx.rst>`

.. # hopefully none of the above lines broke the rst parser and causing page render to break, commenting them out using dot-dot hack to check ... at least rstcheck didn't split out SEVERE error on them


==========================================================


.. sidebar::
.. contents::

==========================================================

Pre-formatted code block (literal text)
---------------------------------------

::

        blank line and indent after :: to start a pre-formatted mono-space text block
	seems like no way around the indent... which is sad cuz i was just hoping for a .txt with some highlight feature.  
	think within code file...  create my own markup lol
        another line
        another line
		github render the above into final text as well.  easier just have them at end of line
        another line

back to normal text here after a blank line


.. code:: bash

        # use
        #
        # .. code:: bash
        #     echo "Hello world"
        #
        # to create pre-formatted code block with syntax highlight.
        # be careful though, as (typo?) or (some system?) may treat it as execution directive
        # below should show command and not execution of 'date' 'hostname' and 'uptime' ?
        date
        hostname
        uptime
        # okay, github seems to render this as code block with highlight... more test:
        FECHA=`date +%Y%m%d-%H%M`
        LIST=$( seq 1 10 )
        for ITEM in $LIST; do
                echo $ITEM > /dev/null
        done

back to normal text here

One thing that *.md* might be better than .rst is that 
pre-formatted code block can be delimited with triple backticks (optionally followed by language name)
``` bash
echo "code here"
echo "more code here"
echo "there is no need for indent"
```

The above does not render as desired in .rst, but would work in .md.

But I rather indent than deal with # as header which attract attention rather than as "low priority" comment



next ==== line is rendered as horizontal line:

==========================================================

References
----------

- wikipedia on .rst: https://en.wikipedia.org/wiki/ReStructuredText#Examples_of_reST_markup
- reStructuredText quick ref: http://docutils.sourceforge.net/docs/user/rst/quickref.html
- reStructuredText primer: http://docutils.sourceforge.net/docs/user/rst/quickstart.html
- preformatting samples, but not necessarily code syntax highlight: http://docutils.sourceforge.net/docs/user/rst/quickstart.html#preformatting-code-samples 



.. topic:: Examples 1
Examples that works  
-------------------

Note that single dash subline make this a subheader but no ruler line below it like the above does

- use dash to start list
- ``double backquotes``  highligt in reverse text and monospace font
- *single asterist* to delimited *italic text* 
- **double asterisks** became **bold**
- nice thing is vim will highlight text specially from .rst syntax (mostly)



.. topic:: Examples 2
Examples 2, lists (that works)
------------------------------


List with human numbers

1) a numbered list
2) another entry
3) third entry


List with hash, and let rst parser generate the correct number

#) a numbered list
#) another entry
#) third entry

Nested list.  use dash.  Let .rst render deal with numbering.  using numbers, letters, hash just confuses it.

- starting a list
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


------------------------------

bunch of ---- in a line by itself treated by .md as horizontal line, same in .rst?  --> Yes



.. topic:: Examples and tests
More examples, but many don't work correctly.  they were my learning experience.
--------------------------------------------------------------------------------


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

**> no good solution, see reStructuredText_hard_line_break.rst <**

hard new line in rst need to be prefixed in an annoying way.

| the pipe in the beginning indicate where line breaks are
| another line

another trick was to use raw HTML, but that's for web rendering only.  see
https://stackoverflow.com/questions/51198270/how-do-i-create-a-new-line-with-restructuredtext/51199504

.md allow use of \
at end for hard line break
or the double space at end, which works, except it is invisible and some text editor automatically stripe end white space.



----

ref: http://docutils.sourceforge.net/docs/user/rst/quickstart.html#preformatting-code-samples

	two colons and next line with indent 
	indicate literal text
	good for quoting

	blank lines still continues the literal

end block with text back at the same original indent level
back to normal text
something about using two periods, code and two colons and language to start code block

----


I wonder the stuff that SLACK use, how is it in .rst?

Example nested list with dash
----------------------

- `backquote`      
- `backquote`       # don't seems to be rendered any differently, even though vim did highlight it
- doc says single backquote would actually be executed, but not the case in github parser?
  but that's prob why vim highlight single backquotes especially.
- 'single quote'
- 'single quote'	# again, everything is verbatim here
- "double quote"
- lets try with two quotes
    * ``double backquotes``  yes this was highligted in reverse text and monospace font
    * ''double single quotes''  
    * ""double double quotes""
- lets try with triples:
    * ```triple backquotes```  the extra backquote shows up in the final text
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





| ---------------------------------------------------------------------------
|   this is an example of boxed text, but github don't render them as boxed 
|   it was not to have the pipe in front, but github is my primary place for rst
|   and it is utterly broken, so can't afford to have a thing that really break
| ---------------------------------------------------------------------------

| ===============================
|  another example of boxed text
| ===============================

(note the starting space in the text line vs the dash line)


Does github support this markup?  it did for NeRSC Shifter... 
But I need to enable such support in my own repo for it to render?
No, just needed to remove the .md text that was in the bottom
it somehow confused the parser and so didn't render it at all.
now that there is no markdown format text, .rst renders well
(though not which of markdown text threw off the parser)




Preformatted code example
===========================
.. topic:: code block

(the topic wasn't listed in contents:: , but the heading line was listed instead.  so, may have no use for ``topic``)

reference for preformatting: http://docutils.sourceforge.net/docs/user/rst/quickstart.html#preformatting-code-samples
reference for directive: http://docutils.sourceforge.net/docs/user/rst/cheatsheet.txt


::

	two colons, blank lines before and after it,  next lines with indent 
	this should be treated different than next block
	arrggg... i should break down the examples into multiple rst files
	so that one error won't cascade to downstream texts :(


::
	two colons and next line with indent 
	indicate literal text
	good for quoting

	blank lines still continues the literal
	.. directive:: 
	see http://docutils.sourceforge.net/docs/user/rst/cheatsheet.txt
	it seems that 
	.. code:: bash
	will actually tell parser to run the code in the language specified, 
	not to display with language syntax...

back to normal text
something about using two periods, code and two colons and language to start code block


.. code-block:: console
	echo "hello world"
	for F in $( ls -1 /etc ); do
		echo $F
	done
end of code block

::
	above was with 
	..code:: bash



raw text
********

trying raw, it gets reverse text block in github.
.. raw::
	these lines are in 
	   raw text
	**double asterisks**  are displayed verbatim
          funky stuff can go in the raw block
	maybe put     code   in this raw section?
	but it can simply be indented and be taken as verbatim text
	except when don't want parser to treat it
	what i want is parser to highlight it
	but in documentation, prob not too important.	
	

back to normal





still here?
===========
.. # previous version of this file, with ---- as title marker, somehow generated a severe error from rstcheck, which might have been what broke the render engine
.. # this at least render now.  see diff 4f698f8 vs 08057af for full list of changes (inet-dev-class), in case other things were the fix.  
.. # reStructuredText_markup.rst:587: (SEVERE/4) Title level inconsistent:


wow, apparently i wrote a lot before.  or pasted a lot... \
a lot of stuff in middle are dealing with lists


Files location
==============

location of .rst and .md files are in 2 places so that I can see how it got rendered
  - psg/reStructuredText_markup.rst
  - https://github.com/tin6150/inet-dev-class/rst_md

  PSG version will be master.  inet-dev-class is a cache (and not really needed, as error in rst will cause github not to render in both places, so just need to fix the error!).  


Example os .rst that I maintain
====================================

ones that I think has features I wondered how they would work out...

* https://github.com/tin6150/covid19_care_capacity_map 
   - glossary term, really just to force indent block of text.  messy, no way to do hard line break, so easier to just use lots of nested bullet lists
   

RST command marker
==================

dot_dot is command for rst parser.  eg marking code block, specifying language

undercore before text was also command, for linking doc, and if not done correctly seems to break parser and don't render page anymore

colon-word-colon  can be delimiter for doc, ref, download, etc.

comments
--------

dot-dot is actually command to rst parser, but if it is not understood, it is just skipped, so coaxed as also marker for comment #dot-dot-hack
.. this can be used as comment line in rst, ie, not displayed
.. so vim modeline is set as rst comment

.. # use 8-space tab as that's how github render the rst
.. # vim: shiftwidth=8 tabstop=8 noexpandtab paste 
