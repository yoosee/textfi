module ArticlesHelper
  def url
    base_url = 'http://zero.init.org:3000' # temporary
    base_url + @alt_url.to_s
  end

end
