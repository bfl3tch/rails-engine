FactoryBot.define do
  factory :merchant do
    name { Faker::TvShows::Seinfeld.character }
  end
end
