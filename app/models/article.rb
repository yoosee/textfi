class Article < ActiveRecord::Base
  belongs_to :user
#  has_many :media, :dependent => :destroy
  enum status: { draft: 0, published: 1 }

  before_save {
    self.alt_url = alt_url.gsub(/^\//, '-')
  }

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 200 }
  validates :content, presence: true
  validates :alt_url, uniqueness: { case_sensitive: false }, length: { maximum: 500 }, allow_blank: true

  acts_as_taggable_on :tags

  attr_accessor :summary_image, :summary_content, :similar_tagged

  def previous
    Article.unscoped.where(["id < ?", self.id]).published.order("published_at DESC").first
  end

  def next
    Article.unscoped.where(["id > ?", self.id]).published.order("published_at ASC").first
  end

  def url
    base_url = Blog.find(self.blog_id).baseurl + '/articles/'
    self.alt_url ? base_url + self.alt_url : base_url + self.id.to_s
  end

end
