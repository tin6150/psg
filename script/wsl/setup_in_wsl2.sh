

# mostly commands to run after wsl is up

# wsl2 LL486
# note that there could be a default bash vs ubuntu 22.04 lts  using /dev/sdc and /dev/sdd

#### install wsl itself

# wsl --install
# wsl --update
# wsl --list


# may want to cut-n-paste rather than run it at this time
# 2024.0229


cd $HOME

( hostname; pwd; df -h . ) > _DIR_INFO.txt
# manually create a _THIS_IS...txt file, so that things are easy determinable say in explorer

# try to do most work in C_tin, accessible across multiple wsl instance and windows.
ln -s /mnt/c/tin ./C_tin

[[ -d /mnt/c/tin/tin-git-Ctin ]] && mkdir /mnt/c/tin/tin-git-Ctin
ln -s /mnt/c/tin/tin-git-Ctin .


ln -s /mnt/c/Users/tin61/ ./winHome
ln -s /mnt/c/Users/tin61/Downloads/  	./winDownloads
# not sure where Desktop is...



#### apt stuff , see new script, fairly idempotent to run







