class TextfiMarkdown < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants

  require 'json'

#  def preprocess text
#  end

  def header text, level
    level += 1 # hn starts from +1 level. e.g. "#" => <h2>
    "<h#{level}>#{text}</h#{level}>"
  end

#  def link link, title, content
#  end

  def image link, title, alt_text
    img = nil
    # Convert Medium mmodel ID to image URL
    title = alt_text if !title or title.empty?
    if /id:(\d+)/ =~ link 
      media = Medium.find($1)
      img = "<img src='#{media.image.url :medium}' alt='#{alt_text}' title='#{title}' class='img-responsive'>"
    else
      img = "<img src='#{link}' alt='#{alt_text}' title='#{title}' class='img-responsive'>"
    end
#    if /asin:(\S+)/ =~ link
    img
  end

  def block_code code, language
    language = :text unless language
    Albino.colorize(code, language)
  end

  def block_quote quote

    # assuming input "> https://twitter.com/...." oneline in quote
    if quote.gsub(/<[^>]+>/,'') =~ /^https?:\/\/twitter\.com[\S]+/
      tw_width = 550
      oembed_url = "https://publish.twitter.com/oembed?maxwidth=#{tw_width}&url="
      req = oembed_url + URI.encode_www_form(quote.gsub(/<[^>]+>/,''))
      res = JSON.parse(open(req).read)
      return res['html']

    # assuming input "> https://www.youtube.com/watch/v=...." oneline in quote
    elsif quote.gsub(/<[^>]+>/,'') =~ /^https?:\/\/(www\.)?youtube\.com\/watch\?v=[\S]+/
      youtube_id = quote.match(/youtube\.com\/watch\?v=([^&"<>]+)/)[1]
      youtube_embed = "<iframe id='ytplayer' type='text/html' width='640' height='360' src='https://www.youtube.com/embed/#{youtube_id}?autoplay=0' frameborder='0'></iframe>"
      return youtube_embed
    else
      return "<blockquote>#{quote}</blockquote>"
    end
  end

#  def codespan code
#  end

end

## markdown = Redcarpet::Markdown.new(TextfiMarkdown, :fenced_code_blocks => true)

