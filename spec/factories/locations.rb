# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    title 'Home'
    address '10 Main St, Boston, MA 02129'

    factory :home_location

    factory :work_location do
      title 'Work'
      address '50 Main Street, Cambridge, MA'
    end

    factory :food_location do
      title 'Food'
      address '13 Main Street, Falmouth, MA'
    end
  end
end
