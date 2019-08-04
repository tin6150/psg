#!/bin/bash


# run script as ./bash_param.sh foo bar baz


echo '$* should expand to all params:'
echo $*


echo '$@ include the command line itself:'
echo $@

echo $0
basename $0
