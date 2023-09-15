# 前情提要

why drawio ， why not visio

vscode不能编辑和渲染visio文件，基于vscode - github的工作会变得很复杂

drawio是一款开源的软件，其绘制框图的能力与visio相当，并且可以直接在vscode中渲染，并且通过drawio绘制的框图也可以导入visio（但是反向貌似不支持-.-）

drawio是免费软件，免受许可证烦恼
# win-drawio的安装
https://www.drawio.com/

# vscode-drawio的安装

装插件

![image](https://github.com/fliibs/EnvSetup/assets/140520566/3188e940-fb0a-4083-bc58-a8015ce012f9)

# 使用过程

如果这张图最后准备倒出到HDD等类似的文档中，建议将vscode的背景调整为 `浅色`  使用（`Ctrl + Shift + P` 进入命令执行，搜索关键词`Color Theme`）

方框，状态等容器在左边的菜单栏中，使用时拖出来即可啊调整方框大小等与visio的操作相似

![image](https://github.com/fliibs/EnvSetup/assets/140520566/985b756a-ce7b-4458-873b-62bca048c8b6)

文本从顶部菜单栏 `+` 标志中选择文本使用

![image](https://github.com/fliibs/EnvSetup/assets/140520566/180436e3-46ae-4ff3-87d3-c0ddf0c420a6)


右侧的菜单栏是当前所选择的对象的属性，如果不小心关闭了右边的菜单栏可以通过红框内的按钮恢复该菜单

![image](https://github.com/fliibs/EnvSetup/assets/140520566/30486074-8d30-421b-b8fb-7bece031262a)

连接线可以直接从容器自带的连接点中拖出，连线的形式可以从顶部的`连接` `航点`选项中进行修改

![image](https://github.com/fliibs/EnvSetup/assets/140520566/f232051a-c1e3-4020-9d43-268a98e15c48) ![image](https://github.com/fliibs/EnvSetup/assets/140520566/78670404-458a-449b-b6c4-65691bbc81ac)

另外，连接线也可以直接从左边的容器中拖出使用

![image](https://github.com/fliibs/EnvSetup/assets/140520566/25e5dfec-e5a7-4d15-bdd9-2418aa7f6ec9)


# 转换到visio

转换第一步 ~~雀氏纸尿裤~~  右键->选择顶点

![image](https://github.com/fliibs/EnvSetup/assets/140520566/7b2c0a19-355d-40c3-8dfd-5b37e02b61ec)

然后在右边的状态栏中取消自动换行与格式化文本的选项

![image](https://github.com/fliibs/EnvSetup/assets/140520566/3eb067e9-2bf3-49a6-adf9-1b4ed1d629fd)

接下来就可以正常导出为office能识别的矢量图模式了，顶部菜单栏选择`文件->Export...->Enter`导出为SVG格式的图片

在visio中导入图片`插入->图片->图片`，之后如果想修改该矢量图中的细节可以选中图片后`右键->组合->取消组合`（如果取消组合一次没有拆开矢量图可以多取消组合几次）
