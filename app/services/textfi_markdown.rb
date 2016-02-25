class TextfiMarkdown < Redcarpet::Render::HTML
  def preprocess text
    media_id_to_url text
  end

  def media_id_to_url text

    text
  end
end

