require_relative 'features_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of the answer
  I want to be able to edit the anwer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to edit the answer' do
    visit question_path question

    expect(page).to_not have_link 'Edit'
  end

  describe 'Author' do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'sees the link to Edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit his answer with invalid parameters', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Answer', with: nil
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Not author' do
    before do
      sign_in another_user
      visit question_path question
    end

    scenario "tries to edit other's answer" do
      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

end
