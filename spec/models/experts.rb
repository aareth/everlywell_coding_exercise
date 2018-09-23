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

  end

end
