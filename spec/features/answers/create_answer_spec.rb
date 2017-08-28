require_relative '../features_helper'

feature 'User can Create on the question page', %q{
  In order to Create on the question page
  As an user
  I want to be able to Create
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates an answer', js: true do
    sign_in(user)
    visit question_path question

    fill_in 'Body', with: 'This is my answer.'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'This is my answer.'
    end
  end

  scenario 'Authenticated user creates an answer with invalid parameters', js: true do
    sign_in(user)
    visit question_path question
    
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user tries to Create' do
    visit question_path question
    expect(page).to_not have_content 'Create'
  end

end
