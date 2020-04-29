#!/bin/bash


# run script as ./bash_param.sh foo bar baz


echo '$* expands to all params:'
echo $*

echo '----------------'

echo '$1 is first param:'
echo $1

echo '$2 is second  param:'
echo $2

echo '----------------'
echo '----------------'


echo '$@ include the command line itself (actually not really... so not sure how it differe from F*):'
echo $@

echo '----------------'

echo '$0 is cmd name:'
echo $0

echo 'basename $0 (exlude path, but include extension)::'
basename $0


## see also record_bios_settings.sh on using arg to invoke diff fn
