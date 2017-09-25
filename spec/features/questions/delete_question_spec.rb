require_relative '../features_helper'

feature 'User can delete his question', %q{
  In order to delete a question
  As an user
  I want to be able to delete my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    given(:another_user) { create(:user) }
    given!(:another_question) { create(:question, user: another_user) }

    scenario 'tries to delete his question', js: true do
      sign_in(user)

      question
      visit question_path(question)
      click_on 'Delete'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'tries to delete another\'s question' do
      sign_in(user)

      visit question_path(another_question)
      expect(page).to_not have_content 'Delete'
    end
  end

  context 'Non-authenticated user' do
    scenario  'tries to delete a question' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete'
    end
  end

end
