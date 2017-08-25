require_relative '../features_helper'

feature 'Create question', %q{
  In order to get anser from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test text'
    click_on 'Create'

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'test text'
    expect(page).to have_content 'Your question is created successfully.'
  end

  scenario 'Authenticated user creates question with invalid parameters' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: nil
    fill_in 'Body', with: nil
    click_on 'Create'

    expect(page).to have_content 'can\'t be blank'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end