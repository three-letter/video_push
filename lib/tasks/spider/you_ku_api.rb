require 'open-uri'
require 'json'

module YouKuApi
    ##根据优酷API接口获取视频信息                            
    #需要根据播放url获取vid                                  
    def self.get_video_object url                                     
      video_id,title,image,plugin = '','','',''
      begin
      content = open(url)
      doc = Hpricot(content)
      rescue
        return
      end
      #获取video_id
      doc.search("script") do |s|
        if s.inner_html.match("var videoId2= '(.*)'")
          video_id = s.inner_html.match("var videoId2= '(.*)'")[1] 
          break
        end
      end
      return if video_id.blank?
      #获取plugin
      doc.search("input[@id=link2]") do |p|
        plugin = p.attributes['value']
      end
      #根据json获取title image
      video_info = ''
      open("http://v.youku.com/player/getPlayList/VideoIDS/" + video_id) do |d|
        video_info = d.read
      end
      video_json = JSON::parse(video_info)
      image = video_json['data'][0]['logo']
      title = video_json['data'][0]['title']
      #根据获取的视频基本信息初始Video对象
      video = Video.new
      video.title = title
      video.image = image
      video.url = url
      video.plugin = plugin
      video
    end

end

