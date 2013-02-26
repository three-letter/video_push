#coding: utf-8
module ApplicationHelper
  #对字符串截取指定长度
  def sub_str(str,len)
    if str.length>len
      str.split(//)[0,len].join()+"..." 
    else
      str
    end
  end

  #根据用户名和时间获取small quote信息
  def quote_small(name, date)
    "由" + name + "于" + time_ago_in_words(date) + "前推荐"
  end
  
  #设置视频主动播放
  def auto_play url
    if url.include?("youku.com")
      url = url + "?isAutoPlay=true"
    end
    url
  end

  #显示标签
  def show_tag tags
    return unless tags
    html = '标签：'
    tags_str = tags.split("-")
    tags_str.each do |tag|
      unless tag.blank?
        html += '<a>' + tag + '</a> '
      end
    end
    html = html + '<br/>'
    html.html_safe
  end
    
end
