xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       APP_CONFIG[:site_name]
    xml.description "The latest quotes from " + APP_CONFIG[:site_name]
    xml.link        root_url

    @quotes.each do |quote|
      xml.item do
        xml.title       'Quote #' + quote.id.to_s

        desc = '<pre>' + h(quote.quote) + '</pre>'
        if quote.comment?
          desc += '<pre>Comment: ' + h(quote.comment) + '</pre>'
        end

        xml.description desc
        xml.link        short_quote_url(quote.id)
        xml.guid        quote.id.to_s + quote.updated_at.to_i.to_s
      end
    end

  end
end
