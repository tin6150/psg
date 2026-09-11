# Dockerfile for creating a fat container with many sys admin tools

# Dockerfile github: https://github.com/tin6150/perf_tools/blob/master/Dockerfile



#FROM r-base:3.6.2
#FROM tin6150/base4metabolic
#FROM rockylinux:9.3
FROM rockylinux:rockylinux:10
#FROM alpinelinux:latest
MAINTAINER Tin (at) LBL.gov

ARG TZ="America/Los_Angeles"

COPY . /perf_tools

RUN touch    _TOP_DIR_OF_CONTAINER_                                                   ;\
    echo "====================================== " | tee -a _TOP_DIR_OF_CONTAINER_    ;\
    echo "Begin Dockerfile build process at " | tee -a _TOP_DIR_OF_CONTAINER_         ;\
    echo "====================================== " | tee -a _TOP_DIR_OF_CONTAINER_    ;\
    hostname | tee -a       _TOP_DIR_OF_CONTAINER_                                    ;\
    date     | tee -a       _TOP_DIR_OF_CONTAINER_                                    ;\
    touch /THIS_IS_INSIDE_DOCKER_CONTAINER                                            ;\
    bash /psg/install_tools.sh  | tee -a install_tools.log              ;\
    echo $? > install_tools.exit.code                                                 ;\
    cd      / 

RUN touch    _TOP_DIR_OF_CONTAINER_                                                   ;\
    echo "====================================== " | tee -a _TOP_DIR_OF_CONTAINER_    ;\
    echo "mousepad editor layer to check size    " | tee -a _TOP_DIR_OF_CONTAINER_         ;\
    echo "====================================== " | tee -a _TOP_DIR_OF_CONTAINER_    ;\
    yum -y install nginx  | tee -a yum_install.log  ;\
    #yum -y install mousepad  | tee -a yum_install.log  ;\
    cd      / 

RUN     cd / \
  && touch _TOP_DIR_OF_CONTAINER_  \
  && TZ=PST8PDT date  >> _TOP_DIR_OF_CONTAINER_  \
  && echo  "Dockerfile. 2026.0910 rocky 9  "     >> _TOP_DIR_OF_CONTAINER_   \
  && echo  "Grand Finale"

# ENV TZ America/Los_Angeles  
# ENV TZ could be changed/overwritten by container's /etc/csh.cshrc
ENV TEST_DOCKER_ENV_1   Can_use_ADD_to_make_ENV_avail_in_build_process
ENV TEST_DOCKER_ENV_REF https://vsupalov.com/docker-arg-env-variable-guide/#setting-env-values
ENV DOCKER_psg "container with web server testing kubernetes workflow"

###ENTRYPOINT [ "/usr/bin/zsh" ]
ENTRYPOINT [ "/usr/bin/bash", "-l", "-i" ]
# if no defined ENTRYPOINT, default to bash inside the container
