class Medium < ActiveRecord::Base
#  belongs_to :article

  has_attached_file :image, styles: { medium: "600x300>", thumb: "120x120>" },
    :default_url => "/image/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end
