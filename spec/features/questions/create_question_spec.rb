require_relative '../features_helper'

feature 'Create question', %q{
  In order to get anser from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  context 'Authenticated user' do
    scenario 'creates question' do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test text'
      click_on 'Create'

      expect(page).to have_content 'Test question'
      expect(page).to have_content 'test text'
      expect(page).to have_content 'Your question was successfully created'
    end

    scenario 'creates question with invalid parameters' do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: nil
      fill_in 'Body', with: nil
      click_on 'Create'

      expect(page).to have_content 'can\'t be blank'
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create question' do
      visit questions_path
      expect(page).to_not have_content 'Ask question'
    end
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
        click_on 'Create'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
        expect(page).to have_content 'Your question was successfully created'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

end
