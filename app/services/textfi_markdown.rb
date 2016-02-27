class TextfiMarkdown < Redcarpet::Render::HTML
  def preprocess text
    media_id_to_url text
  end

  def image link, title, alt_text
    img = nil
    if /id:(\d+)/ =~ link
      media = Media.find($1)
      img = "<img src='#{media.image.url :medium}' alt='#{alt_text}' title='#{title}'>"
    else
      img = "<img src='#{link}' alt='#{alt_text}' title='#{title}'>"
    end
    img
  end

  def media_id_to_url text
    text
  end

  def header text, level
    level += 1 # hn starts from +1 level. e.g. "#" => <h2>
    "<h#{level}>#{text}</h#{level}>"
  end

  def block_code code, language
    Albino.safe_colorize code, language
  end

end

## markdown = Redcarpet::Markdown.new(TextfiMarkdown, :fenced_code_blocks => true)

