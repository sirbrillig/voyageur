FactoryGirl.define do
  factory :user do
    email 'test@test.com'
    password 'foobarfoobar'
    confirmed_at Time.now
  end

  factory :admin, class: User do
    email 'admin@test.com'
    password 'foobarfoobar'
    admin true
    confirmed_at Time.now
  end
end
