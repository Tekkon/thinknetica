require 'rails_helper'

feature 'User can create an answer on the question page', %q{
  In order to create an answer on the question page
  As an user
  I want to be able to create an answer
} do

  given(:question) { create(:question) }

  scenario 'Authenticated user creates an answer' do
    visit question_path question

    save_and_open_page

    fill_in 'Body', with: 'This is my answer.'
    click_on 'Create an answer'

    expect(page).to have_content question.answers.last.body
  end

end
