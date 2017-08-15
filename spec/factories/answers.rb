FactoryGirl.define do
  sequence :body do |n|
    "Answer #{n}"
  end

  factory :answer do
    body "MyText"
  end

  factory :sequence_answer, class: 'Answer' do
    body
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
