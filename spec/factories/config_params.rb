# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :config_param do
    name "MyString"
    param_type "MyString"
    required false
    config_template nil
  end
end
