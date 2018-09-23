require 'rails_helper'

RSpec.describe Expert, type: :model do

  context '#create' do

    it 'grabs the headers' do
      expert = Expert.create(name: 'Martin Fowler', website: 'https://martinfowler.com/')
      expect(expert.headers.count).to eq(13)
    end


    it 'grabs the headers when there is only 1' do
      expert = Expert.create(name: 'Robert C. Martin', website:'https://blog.cleancoder.com/')

      expect(expert.headers.count).to eq(2)
      expect(expert.headers.first.text).to eq("\n  \n   The Clean Code Blog")
    end

    it 'creates a non nil short url' do
      expert = Expert.create(name: 'Robert C. Martin', website:'https://blog.cleancoder.com/uncle-bob/2018/08/28/CraftsmanshipMovement.html')

      expect(expert.short_url).to_not be nil
    end

    it 'creates an accurate short url' do
      expert = Expert.create(name: 'Robert C. Martin', website:'https://blog.cleancoder.com/uncle-bob/2018/08/28/CraftsmanshipMovement.html')
      expert.reload

      full_response = HTTParty.get(expert.website)
      short_response = HTTParty.get(expert.short_url)
      expect(short_response.body).to eq(full_response.body)
    end

  end

  context '#add_friend' do

    it 'adds bidirectional friendships' do
      expert1 = Expert.create(name: 'Robert C. Martin', website:'https://blog.cleancoder.com/uncle-bob/2018/08/28/CraftsmanshipMovement.html')
      expert2 = Expert.create(name: 'Martin Fowler', website: 'https://martinfowler.com/')
      expert1.add_friend(expert2)

      expect(expert1.friends.first).to eq(expert2)
      expect(expert2.friends.first).to eq(expert1)
    end

  end

  context '#find_friend' do
    let(:expert1) {Expert.create(name: 'Robert C. Martin', website:'https://blog.cleancoder.com/uncle-bob/2018/08/28/CraftsmanshipMovement.html')}
    let(:expert2) {Expert.create(name: 'Martin Fowler', website: 'https://martinfowler.com/')}
    let(:expert3) {Expert.create(name: 'Ron Jeffries', website: 'https://ronjeffries.com/')}
    let(:expert4) {Expert.create(name: 'Dave Thomas', website: 'https://pragdave.me/')}
    let(:expert5) {Expert.create(name: 'Jeff Sutherland', website: 'https://www.scruminc.com/scrum-blog/')}
    let(:subject) {"Underwater basketweaving"}

    it 'finds an expert' do
      expert3.headers.create(text: subject)
      expert1.add_friend(expert2)
      expert2.add_friend(expert3)
      friend_path = expert1.find_friend(subject)

      expect(friend_path.size).to eq(2)
      expect(friend_path.first).to eq(expert2.name)
      expect(friend_path.second).to eq(expert3.name + "(\"#{subject}\")")
    end

    it 'finds the shortest path' do
      expert3.headers.create(text: subject)
      expert1.add_friend(expert2)
      expert2.add_friend(expert3)
      expert2.add_friend(expert4)
      expert4.add_friend(expert5)
      expert5.add_friend(expert3)

      friend_path = expert1.find_friend(subject)

      expect(friend_path.size).to eq(2)
      expect(friend_path.first).to eq(expert2.name)
      expect(friend_path.second).to eq(expert3.name + "(\"#{subject}\")")
    end


    it 'finds the expert when path is longer than 1' do
      expert5.headers.create(text: subject)
      expert1.add_friend(expert2)
      expert2.add_friend(expert3)
      expert3.add_friend(expert4)
      expert4.add_friend(expert5)

      friend_path = expert1.find_friend(subject)

      expect(friend_path.size).to eq(4)
      expect(friend_path.first).to eq(expert2.name)
      expect(friend_path.second).to eq(expert3.name)
      expect(friend_path.third).to eq(expert4.name)
      expect(friend_path.fourth).to eq(expert5.name + "(\"#{subject}\")")
    end

  end

end
