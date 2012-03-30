#coding: utf-8
class UsersController < ApplicationController
  before_filter :authentication, :except => [:new, :create, :edit, :login]
 
  def login
    session[:user] = nil
    if request.post?
      @user = User.authenticate(params[:name], params[:pwd])
      respond_to do |format|
        if @user
          session[:user] = @user
          url = session[:last_url]
          session[:last_url] = nil
          format.html{redirect_to (url || users_path)}
        else
          flash[:login_notice] = '用户名或密码错误'
          format.html{render action:'login'}
        end
      end
    end
  end

  def logout
    session[:user] = nil
    session[:last_url] = nil
    redirect_to login_path
  end
  
  def index
    @users = User.all
    respond_to do |format|
      format.html
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
          session[:user] = @user
          format.html{redirect_to action:"index"}
      else
        format.html{render action:"new"}
      end
    end
  end
  
  def show 
    @user = User.find(params[:id])
    respond_to do |format|
      format.html{render action:"show"}
    end
  end
  
  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        if params[:user][:logo].blank?
          format.html{ redirect_to action:"index" }
        else
          format.html{render :action => "crop"}
        end
      else
        format.html{ render action: "edit" }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html{redirect_to action:"index"}
    end
  end
end
