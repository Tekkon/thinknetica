require_relative '../features_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path question
  end

  scenario 'User adds file when asks the question' do
    fill_in 'Body', with: 'This is my answer.'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', 'uploads/attachemnt/file/1/spec_helper.rb'
    end
  end
end
