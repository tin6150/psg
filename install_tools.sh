
#!/bin/bash 

# script to install various tools (via yum mostly/only)
# to be called by Dockerfile 
# and future by Singularity def file


date            | tee    /_install_tool_sh_
echo "start"    | tee -a /_install_tool_sh_

# rocky 9/dnf does not have a -t option

yum -y update 
#yum -y install  wget 
yum -y install  --allowerasing curl \
		nginx \
		epel-release  




date            | tee -a /_install_tool_sh_
echo "end"      | tee -a /_install_tool_sh_


# vim: noexpandtab tabstop=4 paste
