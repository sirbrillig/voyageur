FactoryGirl.define do
  factory :user do
    email 'test@test.com'
    password 'foobar'
    password_confirmation 'foobar'
  end

  factory :admin do
    email 'admin@test.com'
    password 'foobar'
    password_confirmation 'foobar'
    admin true
  end
end
