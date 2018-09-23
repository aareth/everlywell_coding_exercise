class Expert < ActiveRecord::Base
  has_many :headers
  after_create :grab_headers_from_website, :shorten_url

  def grab_headers_from_website
    response = HTTParty.get(self.website)
    doc = Nokogiri::HTML(response.body)
    get_headers(doc, "h1")
    get_headers(doc, "h2")
    get_headers(doc, "h3")
  end

  def get_headers(doc, header_tag)
    headers_by_tag = doc.css(header_tag)
    headers_by_tag.each do |header|
      self.headers.create(text: header.text)
    end
  end

  def shorten_url
    self.short_url = Bitly.client.shorten(website).short_url
  end

end
