FactoryGirl.define do
  sequence :title do |n|
    "Question #{n}"
  end

  factory :question do
    title 'Question'
    body 'Hi! I have a question.'
  end

  factory :sequence_question, class: 'Question' do
    title
    body 'Hi! I have a question.'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
