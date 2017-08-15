require 'rails_helper'

feature 'User can create an answer on the question page', %q{
  In order to create an answer on the question page
  As an user
  I want to be able to create an answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates an answer' do
    sign_in(user)
    visit question_path question

    fill_in 'Body', with: 'This is my answer.'
    click_on 'Create an answer'

    expect(page).to have_content question.answers.last.body
    expect(page).to have_content 'Your answer is created successfully.'
  end

  scenario 'Non-authenticated user tries to create an answer' do
    visit question_path question

    fill_in 'Body', with: 'This is my answer.'
    click_on 'Create an answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
