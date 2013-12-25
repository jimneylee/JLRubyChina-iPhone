社区API开放接口问题反馈

后台API接口有几个还需要完善下，具体问题如下：
1、帖子回复列表：
    API: http://ruby-china.org/api/topics/16194.json
    
 * a、回复列表未按id排序，会错乱，建议在接口中处理。
    参照帖子：http://ruby-china.org/topics/16194

 * b、已删除的楼层，在回复列表数据中无法判断
    接口数据建议放一个占位数据，客户端解析发帖没有id，认为帖子已删除。跟网页一致显示已删除。保证楼层跳转正确。

3、帖子的(取消)关注成功返回是json、(取消)关注失败返回是false，而收藏成功返回是true or false
    API: http://ruby-china.org/api/v2/topics/:id/follow.json
    API: http://ruby-china.org/api/v2/topics/:id/unfollow.json
    API: http://ruby-china.org/api/v2/topics/:id/favorite.json
    返回结果不统一，建议统一格式返回

4、个人主页接口中最近5条帖子的信息不完整
    API: http://ruby-china.org/api/users/:user.json

5、建议增加精华贴接口，这样方便大家通过客户端查阅社区优秀的帖子

6、http://ruby-china.org/api/topics.json 默认是热门贴。
    建议增加一个type类型，实现分类查看: 默认 /  优质帖子 / 无人问津 / 最新创建

望采纳！Merry Christmas!