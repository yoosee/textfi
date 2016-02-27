module ArticlesHelper
  def url
    base_url = 'http://zero.init.org:3000' # temporary
    base_url + @alt_url.to_s
  end

  def markdown
     Redcarpet::Markdown.new(TextfiMarkdown, 
                             fenced_code_blocks: true,
                             autolink: true,
                             hard_wrap: true
                            )
  end
end
