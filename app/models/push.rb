class Push < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  #设置虚拟属性url 用于根据用户输入视频播放地址生成对应的视频
  attr_accessor :url
end
