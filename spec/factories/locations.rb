# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    title 'Home'

    factory :home_location do
      address '10 Main St, Boston, MA 02129'
    end

    factory :work_location do
      address '50 Main Street, Cambridge, MA'
    end
  end
end
