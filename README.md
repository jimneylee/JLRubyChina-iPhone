## Ruby China社区和V2EX社区接口通用客户端

[Ruby China](http://ruby-china.org/)社区接口，社区有：[Ruby China](http://ruby-china.org/)、[Tester Home](http://testerhome.com/)

[V2EX](http://www.v2ex.com/)社区接口：[V2EX](http://www.v2ex.com/)

## 强烈提醒，勿随意发帖测试
请把玩这个客户端源码的同学，不要在上面几个社区上随意发帖测试，谢谢配合。

## THKS To Contributors
[**luzhiyongGit**](https://github.com/luzhiyongGit)

##JLRubyChina-iPhone
希望能给上面几个社区活跃的同学带来一点帮助，节省一点时间。欢迎大家在使用过程中，提出改进建议和意见。同时期望更多的同学参与学习交流，维护和优化APP。

## 开发环境
XCode5 iOS7.x & iOS6.x

## 编译安装
1、下载[最近的Release版本](https://github.com/jimneylee/JLRubyChina-iPhone/releases)，直接编译即可安装。

2、fork后clone到本地，手工添加依赖库安装方法
* 1、submodule更新

``` bash
$ git submodule init 
$ git submodule update
```
注：`git submodule update`无法更新依赖库时，请按如下重新添加：
``` bash
$ git submodule add https://github.com/jimneylee/JLNimbusTimeline.git vendor/JLNimbusTimeline
$ git submodule add https://github.com/jimneylee/MarkdownSyntaxEditor.git vendor/MarkdownSyntaxEditor
$ git submodule add https://github.com/jimneylee/TSEmojiView.git vendor/TSEmojiView
```
* 2、[CocoaPods](http://cocoapods.org)更新

``` bash   
$ pod install
```   
注：如需要添加其他依赖库，请修改Podfile

* 3、替换pod添加的依赖库
   用工程`vendor`目录下的`Nimbus_fixbug`和`JSONKit_fixerror`中的文件，替换pod添加的对应文件。
   `Nimbus_fixbug`是为了解决帖子列表高亮名字或链接无法点击。
   `JSONKit_fixerror`为了解决编译引起的错误和警告。

>其实这个JSONKit是无用的，但是由于JSONKit是Nimbus的submodule递归依赖引入，所以在Nimbus没有发布新的版本，暂时只能这样处理。之前考虑过'git submodule add'依赖nimbus，去掉这个JSONKit库，但是会是工程膨胀，得不偿失。
>有问题，请添加到issue中！

4、通过'JLRubyChina.xcworkspace'打开项目，也可以[自定义xopen命令](http://jimneylee.github.io/2014/01/09/add-xopen-command-to-open-xcode-workspace/)便捷打开

![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/ErrorResolve/open_xcworkspace.jpg)

# ERROR解决方法
1、帖子列表高亮名字或链接无法点击

   官方push到CocoaPods的nimbus 1.0.0版本，存在NIAttributedLabel在UITableViewCell中link无法响应touch的bug
   请暂时用Nimbus_fix目录下的5个文件（主要就是修改了NIAttributedLabel文件）替换Pod工程中Nimbus里面对应的这5个文件
   参考：http://stackoverflow.com/questions/17467086/using-niattributedlabel-in-uitableviewcell

2、若出现这个问题：'vendor/JLNimbusTimeline' already exists in the index
``` bash
$ git rm --cached vendor/JLNimbusTimeline
```
3、若出现这个问题：fatal: not removing 'vendor/JLNimbusTimeline' recursively without -r
``` bash
$ git rm -r --cached vendor/JLNimbusTimeline
```
4、如果JLNimbusTimeline里面编译出错，`git submodule update`无法更新时，请删除JLNimbusTimeline重新添加，步骤如下：

* 1、`.git/config`删除依赖JLNimbusTimeline相关,`vi .git/config`
* 2、删除`.git/modules/vendor`下JLNimbusTimeline目录,`rm -rf .git/modules/vendor/JLNimbusTimeline`
* 3、到工程vendor目录，删除JLNimbusTimeline,`rm -rf vendor/JLNimbusTimeline`
* 4、删除`git submodule add`对应的cache,`git rm --cached vendor/JLNimbusTimeline`
* 5、重新添加submodule,
`git submodule add https://github.com/jimneylee/JLNimbusTimeline.git vendor/JLNimbusTimeline`

5、若出现这个问题：diff: /../Podfile.lock: No such file or directory
   diff: /Manifest.lock: No such file or directory 
   error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.
``` bash
$ [sudo]pod install
```
6、若出现这个问题：library not found for -lPods

   解决方法1、没有通过pod update生成的JLRubyChina.xcworkspace来打开工程

![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/ErrorResolve/open_xcworkspace.jpg)

   解决方法2、Pods工程中，试着如下修改TARGETS的Pods，今天搞了一上午才解决这个错误问题
![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/ErrorResolve/not_found_pods.png)

7、若`git submodule add https://github.com/jimneylee/JLNimbusTimeline.git vendor/JLNimbusTimeline`出现这个问题：

    A git directory for 'vendor/JLNimbusTimeline' is found locally with remote(s):
    origin	https://github.com/jimneylee/JLNimbusTimeline.git
    If you want to reuse this local git directory instead of cloning again from
    https://github.com/jimneylee/JLNimbusTimeline.git
    use the '--force' option. If the local git directory is not the correct repo
    or you are unsure what this means choose another name with the '--name' option.
``` bash
$ cd ./git/modules/vendor
$ rm -rf JLNimbusTimeline
```

# 多个git server仓库同步
今天研究了多个git server仓库同步，把项目同步到[osc](http://git.oschina.net)和[gitcafe](https://gitcafe.com)，不熟悉如何同步到多个git server，可以参考我的[这篇blog](http://jimneylee.github.io/2013/12/20/git-push-multi-server/)，仓库地址分别如下

github:https://github.com/jimneylee/JLRubyChina-iPhone

gitcafe:https://gitcafe.com/jimneylee/JLRubyChina-iPhone

oschina:http://git.oschina.net/jimneylee/JLRubyChina-iPhone

csdn:https://code.csdn.net/jimney_ljj/JLRubyChina-iPhone

使用相同的ssh key，同步还是很方便的，后面考虑进一步精简步骤，自动化发布到各个git server

### DONE
1、首页热门帖子显示

2、帖子详细浏览、帖子回复列表

3、帖子关注、收藏、@某人

4、回复帖子支持表情选择

5、发帖到指定分类，支持markdown语法

6、分类节点列表查看

7、酷站分组显示

8、会员TOP N查看

9、我的主页，已发帖子、收藏帖子查看

10、Ruby China Wiki

11、更多功能包含：清空缓存、更新检测、给我评分、关于APP

12、帖子列表支持markdown语法解析显示(仅使用于7.x)

13、网络2G/3G/WIFI切换提示


### DOING
1、经公测稳定，提交AppStore审核，方便大家下载使用
2、与后台API接口修改确认，参见API Problem文档说明


### TODO
1、与后台API接口修改确认，参见API Problem文档说明

2、发帖添加表情选择

~~3、帖子列表支持markdown语法解析显示~~

~~4、分类节点做分组与排序~~

5、个人主页详细资料

~~6、网络2G/3G/WIFI切换提示~~

7、发布模式下需屏蔽No Point分类

8、增加社交组件分享

9、经公测稳定，提交AppStore审核，方便大家下载使用

10、如果需要的话，添加友盟统计

## LICENSE
本项目基于MIT协议发布
MIT: [http://rem.mit-license.org](http://rem.mit-license.org)

# Screenshots
![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/default.png)
![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/home_activity_topics.png)


![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/left_menu_side.png)
![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/node_select.png)


![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/topic_reply.png)
![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/home_page.png)


![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/nodes.png)
![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/outside_link_sites.png)


![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/top_members.png)
![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/more.png)
