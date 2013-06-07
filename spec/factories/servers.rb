# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :server do
    name "MyString"
    ip "MyString"
    num_jobs 1
  end
end
