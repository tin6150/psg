
Sphinx is the python doc generator, it is RST based, but also add extensions, so not all sphynx construct works
for git* rendered web pages.

inter-document link (don't want full URL thing)

https://stackoverflow.com/questions/37553750/how-can-i-link-reference-another-rest-file-in-the-documentation

this probably should have worked, in Greta conf/README.rst


* :doc:`./FAQ-dev-env.rst` : FAQ on the GRETA DEV env, info on how to login to internal nodes, vpn, etc.

but it doesn't, probably cuz it need some sphynx extension 
which gitlab doesn't support 


there might be some error.
but github https://github.com/greta-sw/config#id1
and gitlab https://greyhound.lbl.gov/greta/config
both render them strangely.

this might have been one of the thing that .md is easier?


Well, Rmd is md based.
i disliked # for title rather than de-emphasize, but maybe use // for that purpose

code block in .md seems easier to manage
cuz rst would always insist on indent for the block, which I also hate to do
