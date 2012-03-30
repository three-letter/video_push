#coding: utf-8
require 'digest/sha1'

class User < ActiveRecord::Base
  attr_accessor :pwd_confirmation
  validates_presence_of :name, :message => '用户名不为空'
  validates_uniqueness_of :name, :message => '用户名已经存在'
  validates_presence_of :pwd, :message => '密码不能为空', :on => :create
  validates_confirmation_of :pwd, :message => '密码不一致' 
  
  #用户关联的对象模型
  has_many :pushes
  has_many :videos, :through => :pushes
    
  #设置用户头像属性
  has_attached_file :logo, :styles => { :small => "60x60#", :large => "300x300>" }, :processors => [:cropper],
                          :url  => "/assets/logos/:id/:style/:basename.:extension",
                          :path => ":rails_root/public/assets/logos/:id/:style/:basename.:extension"
  #validates_attachment_presence :photo
  #validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png'] 
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_logo, :if => :cropping?
          
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
  def logo_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(logo.path(style))
  end

  def pwd;@pwd;end
  def pwd=(pwd)
    @pwd = pwd
    return if pwd.blank?
    self.password = User.encrypt_pwd(pwd)
  end

  def self.authenticate(name,pwd)
    user = User.find_by_name(name)
    if user
      user=nil unless user.password == User.encrypt_pwd(pwd)
    end
    user
  end

  private
    def self.encrypt_pwd(pwd)
      Digest::SHA1.hexdigest(pwd)
    end
    def reprocess_logo
      logo.reprocess!
    end
end
