require_relative '../features_helper'

feature 'User can Create on the question page', %q{
  In order to Create on the question page
  As an user
  I want to be able to Create
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: user) }

  context 'Authenticated user' do
    scenario 'creates an answer', js: true do
      sign_in(user)
      visit question_path question

      fill_in 'Body', with: 'This is my answer.'
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'This is my answer.'
      end
    end

    scenario 'creates an answer with invalid parameters', js: true do
      sign_in(user)
      visit question_path question

      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
      expect(current_path).to eq question_path(question)
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create an answer' do
      visit question_path question
      expect(page).to_not have_content 'Create'
    end
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path question
      end

      Capybara.using_session('guest') do
        visit question_path question
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'This is my answer.'
        click_on 'Create'

        within '.answers' do
          expect(page).to have_content 'This is my answer.'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'This is my answer.'
        end
      end
    end

    scenario "answer not appears on other questions's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path question
      end

      Capybara.using_session('guest') do
        visit question_path another_question
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'This is my answer.'
        click_on 'Create'

        within '.answers' do
          expect(page).to have_content 'This is my answer.'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to_not have_content 'This is my answer.'
        end
      end
    end
  end

end
