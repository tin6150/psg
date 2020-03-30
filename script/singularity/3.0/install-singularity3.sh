
#https://sylabs.io/guides/3.0/user-guide/installation.html#install-from-source


#export VERSION=3.0.3 && # adjust this as necessary \

# 3.5.3 is latest on 2020-03-26

### pfff... no go 1.13 in this ubuntu 18.04 box :(
### then ubuntu 20.04 don't have a singularity-container in apt yet?!

export GOPATH=/opt/go

export VERSION=3.5.3 # adjust this as necessary 

    mkdir -p $GOPATH/src/github.com/sylabs 

    cd $GOPATH/src/github.com/sylabs 

    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && \
    tar -xzf singularity-${VERSION}.tar.gz && \

    cd ./singularity 
    ./mconfig

    ./mconfig 
    make -C ./builddir 
    sudo make -C ./builddir install

# INSTALL /usr/local/bin/run-singularity
# INSTALL /usr/local/etc/singularity/nvliblist.conf
# INSTALL /usr/local/etc/singularity/cgroups/cgroups.toml
# INSTALL SUID /usr/local/libexec/singularity/bin/starter-suid

# INSTALL CNI PLUGIN /usr/local/libexec/singularity/cni/ptp
# INSTALL CNI PLUGIN /usr/local/libexec/singularity/cni/vlan
# INSTALL CNI PLUGIN /usr/local/libexec/singularity/cni/bandwidth
# INSTALL CNI PLUGIN /usr/local/libexec/singularity/cni/firewall


