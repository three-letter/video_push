#coding: utf-8
require File.expand_path(Rails.root) + "/lib/tasks/spider/you_ku_api.rb"

class PushesController < ApplicationController
  before_filter :get_video, :authentication, :only => [:new]  
  #用于显示首页的默认10个视推信息
  def pushes
    @pushes = Push.find(:all, :include => [:video, :user],
                              :group => "video_id",
                              :order => "created_at desc",
                              :limit => 10)
    respond_to do |format|
      format.html
    end
  end
     
  def index
  end

  def new
    @push = Push.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @push = Push.new(params[:push])
    @video = YouKuApi.get_video_object(@push.url) unless @video
    respond_to do |format|
      if @video
        video = Video.find_by_url(@video.url)
        has_push = Push.where("user_id=? and video_id=?",session[:user].id,video.id) if video
        if (has_push.nil? || has_push.length==0)
          if @video.id.nil?
            if video
              video.title, video.image, video.plugin = @video.title, @video.image, @video.plugin
              video.save
              @push.video = video
            else           
              @video.save
              @push.video = @video
            end
          end
          @push.user = session[:user]
          if @push.save
            format.html{redirect_to root_path}
          else
            flash[:desc_push] = '操作失败'
            format.html{render action:"new"}
          end
        else
          flash[:desc_push] = '你已经推荐过该视频'
          format.html{render action:"new"}
        end
      else 
          flash[:desc_push] = '该视频播放地址无效'
          format.html{render action:"new"}
      end
    end
  end

  private
    def get_video
      if params[:video_id]
        @video = Video.find(params[:video_id])
      end
    end
  
end
