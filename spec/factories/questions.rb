FactoryGirl.define do
  sequence :title do |n|
    "What happened #{n}?"
  end

  factory :question do
    title 'What happened write after the big bang?'
    body 'I really want to know!'
  end

  factory :sequence_question, class: 'Question' do
    title
    body 'I really want to know!'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
