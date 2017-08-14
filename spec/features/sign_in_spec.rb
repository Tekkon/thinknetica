require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask questions
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign in' do
    wrong_user = User.new(email: 'wrong@test.com', password: '1234')
    sign_in(wrong_user)

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
