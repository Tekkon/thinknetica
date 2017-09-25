require_relative '../features_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of the question
  I want to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user tries to edit the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Author' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees the link to Edit' do
      expect(page).to have_link 'Edit'
    end

    scenario 'tries to edit his question', js: true do
      click_on 'Edit'

      fill_in 'Title', with: 'edited title'
      fill_in 'Question', with: 'edited question'
      click_on 'Save'

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'tries to edit his question with invalid parameters', js: true do
      click_on 'Edit'

      fill_in 'Title', with: nil
      fill_in 'Question', with: nil
      click_on 'Save'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Not author' do
    before do
      sign_in another_user
      visit question_path(question)
    end

    scenario "tries to edit other's question" do
      expect(page).to_not have_link 'Edit'
    end
  end

end
