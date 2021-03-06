class Blog < ApplicationRecord
  validates :baseurl, presence: true, length: { maximum: 200 }, format: { with: URI::regexp(%w(http https)) }, uniqueness: { case_sensitive: false }
  validates :title, presence: true, length: { maximum: 200 }
end
