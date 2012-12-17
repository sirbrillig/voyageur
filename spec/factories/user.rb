FactoryGirl.define do
  factory :user do
    email 'test@test.com'
    password 'foobar'
    password_confirmation 'foobar'
  end
end
