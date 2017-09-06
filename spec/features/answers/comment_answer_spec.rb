require_relative '../features_helper'

feature 'Comment answer', %q{
  In order to leave a feedback
  As an authenticated user
  I want to be able to leave a comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path question
    end

    scenario 'creates a comment', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Comment'
        fill_in 'Comment', with: 'New Comment'
        click_on 'Add comment'

        expect(page).to have_content 'New Comment'
      end
    end

    scenario 'tries to create a comment with invalid attributes', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Comment'
        fill_in 'Comment', with: nil
        click_on 'Add comment'

        expect(page).to_not have_content 'New Comment'
        expect(page).to have_content "Body can't be blank"
       end
    end
  end

  context 'Unauthenticated user' do
    scenario "doesn't see comment link" do
      visit question_path question
      expect(page).to_not have_link 'Comment'
    end
  end

end