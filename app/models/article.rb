class Article < ActiveRecord::Base
  belongs_to :user
#  has_many :media, :dependent => :destroy
  enum status: { draft: 0, published: 1 }

  before_save {
    self.alt_url = alt_url.gsub(/^\//, '')
  }

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 200 }
  validates :content, presence: true
  validates :alt_url, uniqueness: { case_sensitive: false }, length: { maximum: 500 }, allow_blank: true

  attr_accessor :url
    
end
