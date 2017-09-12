FactoryGirl.define do
  sequence :title do |n|
    "What happened write after the big bang? #{n}"
  end

  sequence :body do |n|
    "I really want to know! #{n}"
  end

  factory :question do
    title
    body
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
