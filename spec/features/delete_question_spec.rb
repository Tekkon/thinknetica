require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete a question
  As an user
  I want to be able to delete my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  scenario 'Authenticated user tries to delete his question' do
    sign_in(user)

    question
    visit questions_path
    click_on 'Delete this question'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(page).to have_content 'Your question is deleted successfully.'
  end

  scenario 'Authenticated user tries to delete another\'s question' do
    sign_in(user)

    another_user = create(:user)
    create(:question, user_id: another_user.id)
    visit questions_path
    expect(page).to_not have_content 'Delete this question'
  end

  scenario 'Non-authenticated user tries to delete a question' do
    create(:question, user_id: user.id)
    visit questions_path
    expect(page).to_not have_content 'Delete this question'
  end

end
