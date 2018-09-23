require 'rails_helper'

RSpec.describe Expert, type: :model do

  context "create" do

    it "grabs the headers" do
      expert = Expert.create(name: "Katherine Mangu-Ward", website:"http://www.reason.com")
      expect(expert.headers.count).to eq(171)
    end


    it "grabs the headers when there is only 1" do
      expert = Expert.create(name: "Robert C. Martin", website:"https://blog.cleancoder.com/")

      expect(expert.headers.count).to eq(2)
      expect(expert.headers.first.text).to eq("\n  \n   The Clean Code Blog")
    end

    it 'creates a non nil short url' do
      expert = Expert.create(name: "Robert C. Martin", website:"https://blog.cleancoder.com/uncle-bob/2018/08/28/CraftsmanshipMovement.html")

      expect(expert.short_url).to_not be nil
    end

    it 'creates an accurate short url' do
      expert = Expert.create(name: "Robert C. Martin", website:"https://blog.cleancoder.com/uncle-bob/2018/08/28/CraftsmanshipMovement.html")

      full_response = HTTParty.get(expert.website)
      short_response = HTTParty.get(expert.short_url)
      expect(short_response.body).to eq(full_response.body)
    end

  end

end
