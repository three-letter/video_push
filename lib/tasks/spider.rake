require File.expand_path(Rails.root) + '/lib/tasks/spider/you_ku.rb'
require File.expand_path(Rails.root) + '/lib/tasks/spider/you_ku_api.rb'

namespace :spider do 
  desc "Spider YouKu video info ."
  task :youku => :environment do
    puts "#{Time.now} start spider youku..."
    count = 0
    yk = Spider::YouKu.new
    video_array = yk.spider
    video_array.each do |v|
      video = Video.find_by_plugin(v.plugin)
      if video.nil?
        v.save
        count += 1
      end
    end 
    puts "#{Time.now} end spider youku,update #{count} video..."
  end

  desc "Spider YouKu video info by api ."
  task :youku_api => :environment do
    puts "#{Time.now} start spider youku by api..."
    video = YouKuApi.get_video_object("http://v.youku.com/v_show/d_XMzcyMDAwNDcy.html")
    puts video.nil? 
    if video
      puts video.title + " *** " + video.image + " *** " + video.plugin
    end
  end
end
