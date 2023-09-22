# Latex Environment Setup
*Let's setup a Latex environment!*

## 1.Install texlive-2023

[texlive-2023 镜像地址](https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/)

这里选择texlive-2023.iso就好了。以Linux或者wsl为例，对于wsl用户，不必将镜像文件移入wsl内，放在C盘下即可，即``` C:\texlive2023.iso```。

## 2.校验镜像文件

在```texlive2023.iso```所在目录下，执行：

```shell
md5sum texlive2023.iso
```
md5计算需要完整读取整个镜像文件，因此计算会持续一段时间，请耐心等待。你应该可以得到texlive2023镜像文件的md5值787f087e71695eebd1caafdb2b286060。

## 3.挂载镜像文件

打开wsl，在shell中执行：(原生Linux，需要把/mnt/d/texlive2023.iso换成对应的路径)
```shell
sudo mkdir /mnt/texlive
sudo mount /mnt/c/texlive2023.iso /mnt/texlive
```
后续我们可以在/mnt/texlive中访问安装镜像内部的各种文件。

## 4.启动安装程序

```shell
sudo /mnt/texlive/install-tl
```

将看到以下内容：

```shell
======================> TeX Live installation procedure <=====================
 
======>   Letters/digits in <angle brackets> indicate   <=======
======>   menu items for actions or customizations      <=======
= help>   https://tug.org/texlive/doc/install-tl.html   <=======
 
 Detected platform: GNU/Linux on x86_64
 
 <B> set binary platforms: 1 out of 6
 
 <S> set installation scheme: scheme-full
 
 <C> set installation collections:
     40 collections out of 41, disk space required: 7599 MB (free: 970831 MB)
 
 <D> set directories:
   TEXDIR (the main TeX directory):
     /usr/local/texlive/2023
   TEXMFLOCAL (directory for site-wide local files):
     /usr/local/texlive/texmf-local
   TEXMFSYSVAR (directory for variable and automatically generated data):
     /usr/local/texlive/2023/texmf-var
   TEXMFSYSCONFIG (directory for local config):
     /usr/local/texlive/2023/texmf-config
   TEXMFVAR (personal directory for variable and automatically generated data):
     ~/.texlive2023/texmf-var
   TEXMFCONFIG (personal directory for local config):
     ~/.texlive2023/texmf-config
   TEXMFHOME (directory for user-specific files):
     ~/texmf
 
 <O> options:
   [ ] use letter size instead of A4 by default
   [X] allow execution of restricted list of programs via \write18
   [X] create all format files
   [X] install macro/font doc tree
   [X] install macro/font source tree
   [ ] create symlinks to standard directories
   [X] after install, set CTAN as source for package updates
 
 <V> set up for portable installation
 
Actions:
 <I> start installation to hard disk
 <P> save installation profile to 'texlive.profile' and exit
 <Q> quit
 
Enter command:

```

## 5.调整安装配置
在Enter command中输入```C```

```shell
===============================================================================
Select collections:
 
 a [X] Essential programs and files      w [ ] Italian
 b [X] BibTeX additional styles          x [X] Japanese
 c [X] TeX auxiliary programs            y [X] Korean
 d [ ] ConTeXt and packages              z [X] Other languages
 e [ ] Additional fonts                  A [X] Polish
 f [X] Recommended fonts                 B [X] Portuguese
 g [ ] Graphics and font utilities       C [X] Spanish
 h [X] Additional formats                D [X] LaTeX fundamental packages
 i [ ] Games typesetting                 E [X] LaTeX additional packages
 j [ ] Humanities packages               F [X] LaTeX recommended packages
 k [ ] Arabic                            G [X] LuaTeX packages
 l [X] Chinese                           H [X] MetaPost and Metafont packages
 m [X] Chinese/Japanese/Korean (base)    I [X] Music packages
 n [X] Cyrillic                          J [X] Graphics, pictures, diagrams
 o [X] Czech/Slovak                      K [X] Plain (La)TeX packages
 p [X] US and UK English                 L [X] PSTricks
 s [X] Other European languages          M [X] Publisher styles, theses, etc.
 t [X] French                            N [ ] Windows-only support programs
 u [X] German                            O [X] XeTeX and packages
 v [X] Greek
 P [X] Mathematics, natural sciences, computer science packages
 S [X] TeXworks editor; TL includes only the Windows binary
 
Actions: (disk space required: 5349 MB)
 <-> deselect all
 <+> select all
 <R> return to main menu
 <Q> quit
 
Enter letter(s) to (de)select collection(s):

```
然后输入```deghijkstuvwxyzABCEHIKLMNS```取消其他外语的支持，节省空间。

确认无误后，输入R并回车，回到主界面。

## 6.安装
输入```I```执行安装。

## 7.善后

将安装镜像弹出并删除/mnt/texlive文件夹：
```shell
sudo umount /mnt/texlive
sudo rm -r /mnt/texlive
```

修改~/.bashrc文件
```shell
# Add TeX Live to the PATH, MANPATH, INFOPATH
export PATH=/usr/local/texlive/2023/bin/x86_64-linux:$PATH
export MANPATH=/usr/local/texlive/2023/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2023/texmf-dist/doc/info:$INFOPATH
```

保存并```source ~/.bashrc```，然后检查版本，看是否成功
```shell
tex -v
```

刷新字体缓存
```shell
sudo cp /usr/local/texlive/2023/texmf-var/fonts/conf/texlive-fontconfig.conf /etc/fonts/conf.d/09-texlive.conf
sudo fc-cache -fsv
```

## 8.VSCode插件下载和设置
目前装LaTeX WorkShop, LaTeX Utilities和LaTeX即可

![image](https://github.com/fliibs/EnvSetup/assets/66581448/f6a3a828-86b0-45b9-8968-76246be61ca3)

配置settings.json
```
   "latex-workshop.intellisense.biblatexJSON.replace": {
        
    },
    // use latexmk (xelatex) to build
    "latex-workshop.latex.recipe.default": "latexmk (xelatex)",
    "latex-workshop.latex.autoBuild.run": "never",
    "editor.wordWrap": "on",
    "latex-workshop.view.pdf.invertMode.enabled": "auto",
    "latex-workshop.view.pdf.invert": 0.9,
    
    "latex-workshop.view.pdf.viewer": "tab",
    // clean output file
    "latex-workshop.latex.autoClean.run": "onBuilt", 
    "latex-workshop.latex.clean.fileTypes": [ 
        "*.aux",
        "*.bbl",
        "*.blg",
        "*.idx",
        "*.ind",
        "*.lof",
        "*.lot",
        "*.log",
        "*.out",
        "*.toc",
        "*.acn",
        "*.acr",
        "*.alg",
        "*.glg",
        "*.glo",
        "*.gls",
        "*.ist",
        "*.fls",
        "*.fdb_latexmk",
    ],
```

如果缺少Time New Roman字体(非必须)
```shell
sudo apt-get install ttf-mscorefonts-installer
```

## 9.LaTeX在线渲染
### 9.1 手动
![image](https://github.com/fliibs/EnvSetup/assets/66581448/955d3323-4fd2-4ae5-baa8-d8672de4fd92)

### 9.2 快捷键

```
Control+Alt+B
```

![image](https://github.com/fliibs/EnvSetup/assets/66581448/00014404-c45a-48e8-ac05-25d9c1e2c2e3)



## apt安装和包的安装

可以直接通过apt安装:

  sudo apt install textlive

 

对于缺失的宏定义包，可以通过如下方法查找和安装:

首先安装apt-file工具，这个工具会在可以安装的apt包中查找是否存在待搜索的文件:

  sudo apt install

接下来，针对每个缺失的宏定义包:

  # 例如报错为 "! LaTeX Error: File `ccicons.sty' not found."
  # 则使用一下命令查找:
  apt-file -x search '/ccicons.sty$'

  #上述命令输出:
  # texlive-fonts-extra: /usr/share/texlive/texmf-dist/tex/latex/ccicons/ccicons.sty  
  #说明这个文件可以在"textlive-fonts-extra中找到，安装这个包即可
  sudo apt install textlive-fonts-extra

这里是使用latex制作slices常用的包:

  sudo apt install texlive-pictures
  sudo apt install texlive-latex-extra
  sudo apt install texlive-fonts-extra
  sudo apt install texlive-publishers

其它tex工具:

  sudo apt install chktex


