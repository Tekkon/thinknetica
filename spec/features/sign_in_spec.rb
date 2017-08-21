require_relative 'features_helper'

feature 'User sign in', %q{
  In order to be able to ask questions
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    visit root_path
    click_on 'Sign in'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign in' do
    wrong_user = User.new(email: 'wrong@test.com', password: '1234')

    visit root_path
    click_on 'Sign in'

    fill_in 'Email', with: wrong_user.email
    fill_in 'Password', with: wrong_user.password
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
