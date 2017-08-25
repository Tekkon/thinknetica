require_relative '../features_helper'

feature 'User sign out', %q{
  In order to be able to ask questions
  As an user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)

    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Non-authenticated user tries to sign out' do
    visit root_path
    expect(page).not_to have_content 'Sign out.'
  end

end
