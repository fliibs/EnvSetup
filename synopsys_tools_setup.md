
这个文件记录在wsl上安装synopsys eda工具的流程。

# wsl的设置和基本操作

  在开始安装前，先执行

    wsl --update

  来升级wsl，保证wsl是新版。一些旧版的wsl(例如win10默认带着的)，没有自带的X server，在linux里面打开gui会显示找不到DISPLAY。

  wsl中常用的命令:

    wsl --shutdown #关闭WSL
    wsl -l -v      #查看WSL的状态

  打开windows商店，搜索并安装Ubuntu 22.04

# synopsys eda工具的下载和准备

  可以尝试在这里下载:
  
    https://pan.baidu.com/s/1akQF_n4A5Ho66k5ImVJsLQ 
    
  提取码： 
  
    6enb

  下载后把所有的软件都拷贝到linux目录下。该软件包含的软件有：

  - installer
  - scl
  - vcs2016
  - verdi2016
  - dc2016
  - pt2016
  - fm2015
  - spyglass2016

  这些文件中，vcs,verdi,dc,pt,fm都是安装了就行，它们是在启动的时候向license server申请lic使用，安装时只要能装上就行。

  scl是synopsys的lic server，安装后要先于所有的工具启动，在scl启动时其它工具才能获得lic。

  spyglass有些特别，它不依赖scl，要单独破解。

  installer是synopsys的安装器，用来安装其他所有软件（其实就是解压）。

# 软件安装

  在installer(这次下载的是installer3.2)文件夹下，有一个可执行文件

    SynopsysInstaller_v3.2.run

  切换目录进installer文件夹后运行它，它会完成一些解压。它默认是解压在当前目录下，就按默认配置运行就好。

  解压后会出现一个

    setup.sh

  文件，运行它就会启动Installer。如果运行后提示：

    bash: ./setup.sh: /bin/csh: bad interpreter: No such file or directory

  是因为没安装csh。执行

    sudo apt install csh

  即可。成功执行Installer后会出现如下界面：

  ![image](https://github.com/fliibs/EnvSetup/assets/15517439/7394fc07-acde-4c35-9178-7ad740be927b)

  一路next，把能装的都装上，有的工具有32和64位两个选项，建议是都装上。

  Installer会让你选择一个要安装的工具，及选定要安装工具对应的文件夹（文件夹里是几个.spf文件），然后它会完成解析，给你一堆选项让你选。

  把能选的都选上。

  通过Installer安装

  - scl
  - vcs
  - verdi
  - dc
  - pt
  - formality

  spyglass要单独安装。

# lic的生成和部署

  lic的生成要在windows下完成，在下载到的文件夹中License/scl_keygen目录下，有可执行文件scl_keygen.exe，执行它后会弹出如下界面：
  ![image](https://github.com/fliibs/EnvSetup/assets/15517439/148e89a8-9c09-4174-a9af-3492c63ba31b)
  
  需要注意的是，运行这个文件会被windows病毒防护文件提示可能有毒，windows右下角弹出这个提示的时候要点进去选择信任并执行这个文件。
  如果弹出后一段实现不处理的话，windows会自动删掉这个文件。那就要再从源头下载一次了。如果担心操作不当，可以在运行前备份整个文件夹一份。
  
  在这个工具弹出的界面中，我们需要修改有三个值：
  
  - HOST ID Deamon
  - HOST ID Feature
  - HOST Name
  
  "HOST Name"可以在bash终端中输入
  
    hostname

  来得到，其实就是当前主机名。

  "HOST ID Deamon"和"HOST ID Feature"是相等的，又被称为hostid，其实是某个网口的MAC地址。lic server默认取的是eth0的MAC地址。

  lic server相关命令都由scl安装提供，进入scl安装目录后，再：

    cd ./amd64/bin

  进入这个目录后，就可以使用lic server相关的命令。

  - ./lmhostid   获取当前hostid
  - ./lmgrd      启动lic服务器
  - ./lmstat     查看lic服务器状态
  - ./lmdown     关闭lic服务器

  把当前路径加入$PATH中则可以直接调用，不需要进入该路径。

  另，如果进入文件夹后没找到相关命令，可以尝试：

    sudo apt install lsb

  没有相关库的时候有些命令是不可见的,ll -a也看不到。

  运行:

    ./lmhostid

  则可以看到当前的hostid，通常是00:15:xx。但是我们不能直接使用这个MAC地址。

  在wsl中，存在一个重大问题，那就是每次启动时，都会由WSL随机分配一个MAC地址，目前这个机制是无法改变的。
  因此基于这个MAC地址生成一个lic，在重启之后，MAC地址改变时将会失效。

  在运行中关闭网口，修改MAC，再重启网口，是可以修改MAC地址的，但是会断网，这也是WSL自己的问题。
  WSL在网络这方面还是有点特殊的，和常规的虚拟机不一样。

  因此解决方案不在修改网口这边。

  所幸lic server不会只看eth0这个网口的MAC地址。如下网口名称的mac地址都在它的搜索范围中:

  - eth0
  - wlan0
  - bond0
  - ...
  - bond9
  - vmnic0
  - ...
  - vmnic9

  如果存在多个网口，这些网口的MAC地址都会被识别为hostid。此外，如果存在名为"xp0"的网口，那么这个网口的mac地址
  将会作为唯一的hostid。

  因此我们只要创建一个名为xp0的网口就可以让lmhostid获取一个固定的hostid。运行如下命令:

    ip link add xp0 type bridge
    ip link set xp0 addr 00:11:22:33:44:55

  就可以将hostid固定为"00:11:22:33:44:55"。

  至此，我们就可以输入key_gen需要的三个参数：

    - HOST ID Deamon      00:11:22:33:44:55
    - HOST ID Feature     00:11:22:33:44:55
    - HOST Name           通过运行hostname得到

  随后就可以点击生成，并将它拷贝进wsl中，随意放置路径和命名，我把它命名为Synopsys.dat。随后我们要对这个文件的前两行进行修改:

  对于第一行，将"SERVER"后的名字替换成hostname(运行hostname命令可以得到)
  对于第二行，将"DEAMON snpslmd"后换成" {scl安装路径}/amd64/bin/snpslmd"

  至此就得到了lic_file。

# 设置lic环境变量

  在.bashrc中加入如下代码:
    
    export PATH=$PATH:{scl安装路径}/amd64/bin
    export SNPSLMD_LICENSE_FILE=27000@{该机器的hostname}
    export LM_LICENSE_FILE={lic_file的路径}

    #alias lmg_scl='lmgrd -c $LM_LICENSE_FILE' #注意改路径
  
# 手动启动lic server

  设置好环境变量后，我们先尝试手动启动lic server。在命令行中运行:

    lmgrd -c $LM_LICENSE_FILE

  通常运行这个都会报错，会报各种缺乏形如libxxxx.so.x的错误。例如：

    error while loading shared libraries: libstdc++.so.6

  这个错误的多少和当前机器装的动态链接库的多少有关。(.so都是各种动态链接库)
  这个问题在后续启动其它软件时也会遇到，这里统一列出一些解决方法。

  libstdc++.so.6

    sudo apt install libstdc++6
    sudo apt install lib32stdc++6

  libtiff.so.3
  
    sudo ln -s /usr/lib/x86_64-linux-gnu/libtiff.so.5 /usr/lib/x86_64-linux-gnu/libtiff.so.3
    这个解法的原理是已经安装了更新的.5，把它软链接成.3就可以了。
    如果so.5不在这里，可以运行locate libtiff.so.5找到位置。

  libmng.so.1

    sudo apt-get install libmng2
    sudo ln -s /usr/lib/x86_64-linux-gnu/libmng.so.2 /usr/lib/x86_64-linux-gnu/libmng.so.1

  libpng.so.0
  
    sudo add-apt-repository ppa:linuxuprising/libpng12
    sudo apt update
    sudo apt install libpng12-0

  其他libxxx.so.x

    尝试执行
    sudo apt install libxxx-dev
    就可以安装到对应的链接库
  
  lib问题都解决后，再运行

    lmgrd -c $LM_LICENSE_FILE

  可能会出现

    Failed to open the TCP port number in the license

  的问题，这是因为上一个lic server已经启动并占坑了。(虽然它不不能正确提供lic)
  可以输入

    lmdown

  把服务器关了，然后再次运行。但是lmdown有点慢，可能执行完要等一会才能生效。
  等不及就在windows里执行wsl --shutdown把linux关了。
  然后再开一个terminal就重新启动了(但是ip link相关操作就要重新一下)

  如果出现

    lmgrd can't make directory /usr/tmp/.flexlm

  的问题是由于软件没有这个文件的权限，先看看是否有/usr/tmp这个文件夹，没有就创建一个
  如果/usr/tmp/.flexlm存在，但报了这个错误，则把这个文件的权限改为777.

  
# 设置其他工具的环境变量并启动

  在~/.bashrc中加入:

    export VCS_HOME={vcs安装路径}
    export VERDI_HOME={verdi安装路径}
    export NOVAS_HOME=$VERDI_HOME
    export DC_HOME={dc安装路径}
    export SYNOPSYS=$DC_HOME
    export PT_HOME={pt安装路径}
    export FM_HOME={fm安装路径}
    
    export PATH=$PATH:$VCS_HOME/gui/dve/bin
    export PATH=$PATH:$VCS_HOME/bin
    export PATH=$PATH:$VERDI_HOME/bin
    export PATH=$PATH:$DC_HOME/bin
    export PATH=$PATH:$PT_HOME/bin 
    export PATH=$PATH:$FM_HOME/bin

  在lic server启动后即可运行各个eda工具，运行它们的命令如下：

  - vcs
  - verdi
  - dve
  - dc_shell
  - primetime
  - formality

  启动各个工具时可能会遇到一些问题，这里列出解决方法：

  遇到"unexpected operator":

    sudo dpkg-reconfigure dash 选择No
    主要是将ubuntu默认的shell链接的dash改成传统的bash
    lrwxrwxrwx 1 root root 4 8月 11 09:53 /bin/sh -> dash (为修改之前)
    lrwxrwxrwx 1 root root 4 8月 11 09:53 /bin/sh -> bash

  遇到"/bin/sh: 0: Illegal option -h":

    在ubuntu上，/bin/sh默认是链接到 /bin/dash的，当你从源代码编译软件的时候，dash可能会导致一些错误，因此，把 /bin/sh的链接改为了 /bin/bash即可
    rm -f /bin/sh
    ln -s /bin/bash /bin/sh

# spyglass的安装


# 自动启动lic server

  之前，我们测试了手动启动lic server成功，现在，我们要把手动启动lic server改为开机自动启动。

  执行 ls /lib/systemd/system | grep local 你可以看到有很多启动脚本，其中就有我们需要的 rc-local.service

  打开 rc-local.service脚本内容，内容如下：

    #  SPDX-License-Identifier: LGPL-2.1-or-later
    #
    #  This file is part of systemd.
    #
    #  systemd is free software; you can redistribute it and/or modify it
    #  under the terms of the GNU Lesser General Public License as published by
    #  the Free Software Foundation; either version 2.1 of the License, or
    #  (at your option) any later version.
    
    # This unit gets pulled automatically into multi-user.target by
    # systemd-rc-local-generator if /etc/rc.local is executable.
    [Unit]
    Description=/etc/rc.local Compatibility
    Documentation=man:systemd-rc-local-generator(8)
    ConditionFileIsExecutable=/etc/rc.local
    After=network.target
    
    [Service]
    Type=forking
    ExecStart=/etc/rc.local start
    TimeoutSec=0
    RemainAfterExit=yes
    GuessMainPID=no

  一般正常的启动文件主要分成三部分

  [Unit] 段: 启动顺序与依赖关系
  [Service] 段: 启动行为,如何启动，启动类型
  [Install] 段: 定义如何安装这个配置文件，即怎样做到开机启动
  
  可以看出，/etc/rc.local 的启动顺序是在网络后面，但是显然它少了 Install 段，也就没有定义如何做到开机启动，所以显然这样配置是无效的。 因此我们就需要在后面帮他加上 [Install] 段:

    [Install]
    WantedBy=multi-user.target  
    Alias=rc-local.service

  这个文件定义了开机后会自动执行/etc/rc.local这个文件。但系统默认是没有这个文件的，我们要去新建这个文件，并加入如下代码:

    #!/bin/sh
  
    ip link add xp0 type bridge
    ip link set xp0 addr 00:15:5d:f8:ec:85
    
    rm -rf /var/tmp/*
    {scl安装路径}/amd64/bin/lmgrd -c {lic文件路径} > {lic server启动log路径}

  如前文所说，加上ip link相关操作，设定好新网口。
  
  rm -rf /var/tmp/*是删除所有lock file，防止lic server启动不正常。如果上一次linux非正常关闭，可能会遗留lock文件，导致lic server无法启动。
  
  在这个文件中，由于是开机启动执行，所以所有环境变量都还没定义，就直接用绝对路径来指定命令和文件。这里指定了一个log文件路径，放哪儿都行，方便debug，我是指到home路径下。


# wsl镜像的导出和导入


  
