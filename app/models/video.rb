class Video < ActiveRecord::Base
  has_many :pushes
  has_many :users, :through => :pushes
  
  validates_uniqueness_of :plugin
 
  #以分页的形式获取指定条件的视频
  def self.search(name, page)
    if name
      paginate :per_page => 20, :page => page,
               :conditions => ['title like ?', '%#{name}%'],
               :order => 'created_at desc'
    else
      paginate :per_page => 20, :page => page,
               :order => 'created_at desc'
    end
  end

end
