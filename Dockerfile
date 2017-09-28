FROM centos:5.11
RUN sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf && \
    sed -i 's/mirrorlist/#mirrorlist/' /etc/yum.repos.d/*.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever|baseurl=http://vault.centos.org/5.11|' /etc/yum.repos.d/*.repo
RUN yum update -y && \
    yum upgrade -y && \
    yum install -y \
             gcc-c++ \
             glibc-devel \
             zlib-devel.x86_64 \
             glibc-devel.i386 \
             m4 \
             make \
             wget \
             openssl-devel.x86_64 \
             sqlite-devel.x86_64 \
             ccache \
             java-1.7.0-openjdk.x86_64 \
             bzip2 && \
    yum clean all
RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/bllbldlnx/epel-release-5-4.noarch.rpm && \
    rpm -ivh epel-release-5-4.noarch.rpm
RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/bllbldlnx/gmp-4.3.2.tar.bz2 && \
    tar xvfj gmp-4.3.2.tar.bz2 && \
    mkdir -p gmp-4.3.2/build && \
    cd gmp-4.3.2/build && \
    ../configure --prefix=/usr/gcc_4_9 --build=x86_64-linux-gnu && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf gmp-4.3.2*
RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/bllbldlnx/mpfr-2.4.2.tar.bz2 && \
    tar xvfj mpfr-2.4.2.tar.bz2 && \
    mkdir -p mpfr-2.4.2/build && \
    cd mpfr-2.4.2/build && \
    ../configure --build=x86_64-linux-gnu --prefix=/usr/gcc_4_9 --with-gmp=/usr/gcc_4_9 && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf mpfr-2.4.2*
RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/bllbldlnx/mpc-0.8.1.tar.gz && \
    tar xvfz mpc-0.8.1.tar.gz && \
    mkdir -p mpc-0.8.1/build && \
    cd mpc-0.8.1/build && \
    ../configure --build=x86_64-linux-gnu --prefix=/usr/gcc_4_9 --with-gmp=/usr/gcc_4_9 --with-mpfr=/usr/gcc_4_9 && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf mpc-0.8.1*
RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/bllbldlnx/gcc-4.9.3.tar.bz && \
    tar xvfj gcc-4.9.3.tar.bz2 && \
    mkdir -p gcc-4.9.3/build && \
    cd gcc-4.9.3/build && \
    LD_LIBRARY_PATH=/usr/gcc_4_9/lib:$LD_LIBRARY_PATH LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/ C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu ../configure --build=x86_64-linux-gnu --prefix=/usr/gcc_4_9 --with-gmp=/usr/gcc_4_9 --with-mpfr=/usr/gcc_4_9 --with-mpc=/usr/gcc_4_9 --enable-languages=c++ --enable-threads --enable-multilib --with-system-zlib && \
    LD_LIBRARY_PATH=/usr/gcc_4_9/lib:$LD_LIBRARY_PATH LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/ C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu make && \
    LD_LIBRARY_PATH=/usr/gcc_4_9/lib:$LD_LIBRARY_PATH LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/ C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu make install && \
    cd ../../ && \
    rm -rf gcc-4.9.3* && \
    mkdir -p /usr/local/gcc493/bin && \
    ln -sf /usr/gcc_4_9/bin/gcc /usr/local/gcc493/bin/gcc && \
    ln -sf /usr/gcc_4_9/bin/g++ /usr/local/gcc493/bin/g++ && \
    ln -sf /usr/gcc_4_9/lib/gcc/x86_64-linux-gnu/4.9.3/plugin/include/ansidecl.h /usr/local/include/ansidecl.h && \
    ln -s /usr/bin/ld /usr/local/bin/ld && \
    ln -s /usr/bin/ranlib /usr/local/bin/ranlib && \
    ln -s /usr/bin/strip /usr/local/bin/strip && \
    ln -s /usr/bin/ar /usr/local/bin/ar
WORKDIR /mnt/installers/Python-2.7.11
RUN make install
RUN ln -sf /opt/python27/bin/python /usr/local/bin/python
RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
RUN /usr/local/bin/python get-pip.py
WORKDIR /mnt/installers/scons-2.4.1
RUN python setup.py install
RUN ln -s /opt/python27/bin/scons /usr/local/bin/
RUN rpm -Uvh /mnt/installers/distcc-server-3.1-1.i386.rpm
RUN yum install -y libgcc-4.1.2-55.el5.i386
RUN /mnt/installers/ActiveTcl8.5.18.0.298892-linux-ix86-threaded/install.sh --directory /opt/ActiveTcl-8.5 --demo-directory /opt/ActiveTcl-8.5/demos
RUN ln -s /opt/ActiveTcl-8.5/bin/tclsh /usr/bin/tclsh
RUN cp /mnt/installers/p4 /usr/local/bin/p4 && chmod a+x /usr/local/bin/p4
