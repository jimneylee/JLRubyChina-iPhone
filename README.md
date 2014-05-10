## Ruby China社区和V2EX社区接口通用客户端

[Ruby China](http://ruby-china.org/)社区接口，社区有：[Ruby China](http://ruby-china.org/)、[Tester Home](http://testerhome.com/)

[V2EX](http://www.v2ex.com/)社区接口：[V2EX](http://www.v2ex.com/)

## 强烈提醒，勿随意发帖测试
请把玩这个客户端源码的同学，不要在上面几个社区上随意发帖测试，谢谢配合。

## THKS To Contributors
[**luzhiyongGit**](https://github.com/luzhiyongGit)  [**bachue**](https://github.com/bachue)  [**gbammc**](https://github.com/gbammc)

##JLRubyChina-iPhone
希望能给上面几个社区活跃的同学带来一点帮助，节省一点时间。欢迎大家在使用过程中，提出改进建议和意见。同时期望更多的同学参与学习交流，维护和优化APP。

## 开发环境
XCode5 iOS7.x & iOS6.x

## 编译安装
1、下载[最近的Release版本](https://github.com/jimneylee/JLRubyChina-iPhone/releases)，直接编译即可安装。

2、fork后clone到本地，手工添加依赖库安装方法
* 1、git submodule

``` bash
$ git submodule init 
$ git submodule update
```

* 2、[CocoaPods](http://cocoapods.org)

``` bash   
$ pod install
```

3、通过'JLRubyChina.xcworkspace'打开项目，也可以[自定义xopen命令](http://jimneylee.github.io/2014/01/09/add-xopen-command-to-open-xcode-workspace/)便捷打开

![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/ErrorResolve/open_xcworkspace.jpg)

# ERROR解决方法

1、若出现这个问题：'vendor/JLNimbusTimeline' already exists in the index
``` bash
$ git rm --cached vendor/JLNimbusTimeline
```

2、如果JLNimbusTimeline里面编译出错，`git submodule update`无法更新时，请删除JLNimbusTimeline重新添加，步骤如下：

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

12、帖子列表支持markdown语法解析显示(仅使用于7.x)，效果不是太好

13、网络2G/3G/WIFI切换提示

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
