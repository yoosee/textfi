class Medium < ActiveRecord::Base
#  belongs_to :article

  has_attached_file :image,
    styles: { medium: "800x480>", thumb: "120x120>" },
    convert_options: { 
      all: "-strip"
    },
    default_url: "/image/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end
