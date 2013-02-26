class Push < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  after_save :generate_tag
  #设置虚拟属性url 用于根据用户输入视频播放地址生成对应的视频
  attr_accessor :url

  private
    def generate_tag
      if self.tags
        self.tags.split("-").each do |value|
          unless value.blank?
            has_tag = Tag.find_by_name(value)
            if has_tag.nil?
              tag = Tag.new
              tag.name = value
              tag.save
            else
              has_tag.count = has_tag.count + 1
              has_tag.save
            end
          end
        end
      end
    end

end
