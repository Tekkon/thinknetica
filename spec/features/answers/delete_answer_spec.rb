require_relative '../features_helper'

feature 'User can delete his answer', %q{
  In order to delete my answers
  As an user
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user tries to delete his answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user tries to delete another\'s answer' do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to delete an answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Delete'
    end
  end

end
