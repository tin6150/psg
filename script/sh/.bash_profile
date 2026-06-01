
if [ -f /etc/profile ]; then
        . /etc/profile
fi


# is this creating a source profile looping?
#if [ -f ~/.bashrc ]; then
#	source ~/.bashrc
#fi

# this is AND syntax, POSIX compatibile (ie old sh)
if [ -f ~/.bashrc ]  && [ x"$COMMON_ENV_TRACE" = x"" ]; then
	source ~/.bashrc
fi
