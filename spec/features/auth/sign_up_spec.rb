require_relative '../features_helper'

feature 'User can register', %q{
  In order to be able ask questions
  As an user
  I want to be able to register in the system
} do

  scenario 'Non-authenticated user tries to register' do
    user = build(:user)
    visit root_path
    click_on 'Sign up'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Authenticated user tries to register' do
    user = create(:user)
    sign_in(user)
    visit root_path

    expect(page).to_not have_content 'Sign up' # 'You are already signed in.'
  end

end
