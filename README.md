# 强烈提醒，勿随意发帖测试
请把玩这个客户端源码的同学，不要在[Ruby China](http://ruby-china.org/)社区上随意发帖测试，谢谢配合。

#JLRubyChina-iPhone
[Ruby China](http://ruby-china.org/)社区的iPhone客户端。
希望能给社区的同学带来一点帮助，节省一点时间。欢迎大家在使用过程中，提出改进建议和意见。同时期望更多的同学参与学习交流，维护和优化APP。

# 开发环境
XCode5 iOS7.0

# 更新依赖库
1、submodule更新
``` bash
$ git submodule init 
$ git submodule update
```
注：如需要添加其他的submodule
``` bash
$ git submodule add https://github.com/jimneylee/JLNimbusTimeline.git vendor/JLNimbusTimeline
```
2、[CocoaPods](http://cocoapods.org)更新
``` bash   
$ pod install
```   
注：如需要添加其他依赖库，请修改Podfile

# ERROR解决方法
1、官方push到CocoaPods的nimbus 1.0.0版本，存在NIAttributedLabel在UITableViewCell中link无法响应touch的bug
   请暂时用Nimbus_fix目录下的5个文件（主要就是修改了NIAttributedLabel文件）替换Pod工程中Nimbus里面对应的这个文件
   参考：http://stackoverflow.com/questions/17467086/using-niattributedlabel-in-uitableviewcell
2、若出现这个问题：'vendor/JLNimbusTimeline' already exists in the index
``` bash
$ git rm --cached vendor/JLNimbusTimeline
```
3、若出现这个问题：fatal: not removing 'vendor/JLNimbusTimeline' recursively without -r
``` bash
$ git rm -r --cached vendor/JLNimbusTimeline
```
4、若出现这个问题：diff: /../Podfile.lock: No such file or directory
   diff: /Manifest.lock: No such file or directory 
   error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.
``` bash
$ [sudo]pod install
```
# 完整项目ZIP发布包
  建议不熟悉gitmodule依赖和cocoapods依赖的同学，耐心配置好依赖库，一定会有问题，但是过程中你一定会学习到很多。
  [这边是我自己本地完整的工程](https://github.com/jimneylee/JLRubyChina-iPhone-Release)，给大家预留一份，拉到本地可以直接便宜运行。
  
# DONE
V1.0.0
1、首页热门帖子显示

2、帖子详细浏览、帖子回复列表

3、帖子关注、收藏、回复及@某人

4、发帖到指定分类

5、分类节点列表查看

6、酷站分组显示

7、会员TOP N查看

8、我的主页，已发帖子、收藏帖子查看

9、Ruby China Wiki

10、更多功能包含：清空缓存、更新检测、给我评分、关于APP

# TODO
1、与后台API接口修改确认，参见API Problem文档说明

2、发帖、回复添加表情选择

3、支持markdown语法解析显示

4、分类节点做分组与排序

5、个人主页详细资料

6、网络2G/3G/WIFI切换提示

7、发布模式下需屏蔽No Point分类

8、增加社交组件分享

9、经公测稳定，提交AppStore审核，方便大家下载使用

10、如果需要的话，添加友盟统计

# LICENSE
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
