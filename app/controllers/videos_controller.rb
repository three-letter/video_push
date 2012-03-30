#coding: utf-8

class VideosController < ApplicationController
  before_filter :authentication, :get_video, :only => [:quick_push]
 
  def index
    @videos = Video.search(params[:keyword], params[:page])
    respond_to do |format|
      format.html
    end
  end
  #ajax快速推荐视频
  def quick_push
    @push = @video.pushes.new(params[:push])
    @push.user = session[:user]
    respond_to do |format|
      current_push = Push.find(:first, :conditions => ["user_id=? and video_id=?", session[:user].id, @video_id])
      if current_push
        flash[:quick_push] = '你已经推过该视频！'
      else
        if @push.save
          flash[:quick_push] = '操作成功！'
        else
          flash[:quick_push] = '操作失败！'
        end
      end
      format.js
    end
  end
  

  private 
    def get_video
      @video_id = params[:id]
      return redirect_to videos_path unless @video_id
      @video = Video.find(@video_id)
    end
end
