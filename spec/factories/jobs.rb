# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job do
    server "MyString"
    input "MyString"
    description "MyString"
    owner "MyString"
    status false
    output "MyString"
  end
end
