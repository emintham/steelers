# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :log do
    job_id 1
    input "MyString"
    output "MyString"
    user_id "MyString"
  end
end
