class Expert < ActiveRecord::Base
  has_many :headers
  has_and_belongs_to_many :friends,
              class_name: "Expert",
              join_table: :friendships,
              foreign_key: :user_id,
              association_foreign_key: :friend_user_id
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
    save
  end

  def add_friend(expert)
    self.friends << expert
    expert.friends << self
  end

  def find_friend(subject)
    target_expert_id = Header.find_by_text(subject).expert.id
    @already_visited = []
    path = []
    path = find_shortest_path(self, target_expert_id, path, subject)
    path << self.name
    path.reverse
  end

  def find_shortest_path(current_expert, target_expert_id, path, subject)
    begin
      target = current_expert.friends.find(target_expert_id)
    rescue
    end
    unless target.nil?
      path << Expert.find(target_expert_id).name + "(\"#{subject}\")"
      return path
    end

    current_expert.friends.each do |friend|
      unless @already_visited.include? friend.id
        @already_visited << friend.id
        path = find_shortest_path(friend, target_expert_id, path, subject)
        path << friend.name if !path.empty?
      end
    end
    path
  end

end
