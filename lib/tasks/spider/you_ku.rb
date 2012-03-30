require 'open-uri'
require 'hpricot'

module Spider
  #获取优酷首页的热门视频信息
  class YouKu
    @@host = "http://www.youku.com"
    @@video_info = "ul[@class=v]" #视频信息区域的匹配表达式
    @@video_title = "li[@class=v_title]/a" #视频标题的匹配表达式
    @@video_url = "li[@class=v_title]/a" #视频播放url的匹配表达式
    @@video_image = "li[@class=v_thumb]/img" #视频图片的匹配表达式
    @@video_plugin = "input[@id=link2]" #视频插件url的匹配表达式
    
    #初始化待抓取的页面url
    def initialize(*url)
      @@host = url if url[0]
    end
    
    #视频信息获取入口
    def spider
      base_spider
      plugin_spider
    end
        
    #获取指定页面的视频基本信息
    def base_spider
      @video_array = Array.new #页面的全部视频对象
      doc = Hpricot(open(@@host))
      content = doc.search(@@video_info) do |v|
        video = Video.new
        title,url,image = '','',''
        v.search(@@video_title) do |a|
          title = a.inner_html
          url = a.attributes['href']
        end
        v.search(@@video_image) do |img|
          image = img.attributes['_src']
          if (image.nil?||image.blank?)
            image = img.attributes['src']
          end
        end
        #优酷首页推荐视频中会出现2个异常的thumb显示 在这简单处理下
        if (image.nil?||image.blank?)
          v.search("li[@class=v_thumb]/a/img") do |img|
            image = img.attributes['src']
          end
        end
        video.title = title
        video.url = url
        video.image = image
        @video_array << video
      end
    end

    #获取视频的插件，对于非具体播放页则舍弃
    def plugin_spider
      @video_array.each do |v|
        doc = Hpricot(open(v.url))
        content = doc.search(@@video_plugin) do |c|
          plugin = c.attributes['value'] 
          v.plugin = plugin 
        end
      end
    end

    #根据视频播放地址获取视频插件
    def get_plugin_by_url url
      plugin = ''
      doc = Hpricot(open(url))
      doc.search(@@video_plugin) do |p|
        plugin = p.attributes['value']
      end
      plugin
    end

  end
end

