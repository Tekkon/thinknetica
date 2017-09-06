require_relative '../features_helper'

feature 'Comment question', %q{
  In order to leave a feedback
  As an authenticated user
  I want to be able to leave a comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before { sign_in(user) }

    scenario 'creates a comment', js: true do
      click_on 'Comment'
      fill_in 'Comment', with: 'New Comment'
      click_on 'Add comment'

      expect(page).to have_content 'New Comment'
    end

    scenario 'tries to create a comment with invalid attributes', js: true do
      click_on 'Comment'
      fill_in 'Comment', with: nil
      click_on 'Add comment'

      expect(page).to_not have_content 'New Comment'
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Comment'
        fill_in 'Comment', with: 'New Comment'
        click_on 'Add comment'

        expect(page).to have_content 'New Comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New Comment'
      end
    end
  end

  context 'Unauthenticated user' do
    scenario "doesn't see comment link" do
      visit questions_path
      expect(page).to_not have_link 'Comment'
    end
  end

end
