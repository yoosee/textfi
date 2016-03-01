class TextfiMarkdown < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants

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
    Albino.colorize(code, language)
  end

#  def codespan code
#  end

end

## markdown = Redcarpet::Markdown.new(TextfiMarkdown, :fenced_code_blocks => true)

