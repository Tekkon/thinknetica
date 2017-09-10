require_relative '../features_helper'

feature 'Authentication with facebook', %q{
  In order to authenticate
  As an user
  I want to be able to authenticate from facebook account
} do

  scenario 'can sign in from facebook account' do
    visit root_path
    click_on 'Sign in'

    mock_facebook_hash
    click_on 'Sign in with Facebook'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_content 'Sign out'
  end

  scenario "can handle authentication error" do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit root_path
    click_on 'Sign in'
    click_on 'Sign in with Facebook'
    expect(page).to have_content('Could not authenticate you from Facebook because "Invalid credentials".')
  end

end
