FactoryGirl.define do
  factory :question do
    title 'Question'
    body 'Hi! I have a question.'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
