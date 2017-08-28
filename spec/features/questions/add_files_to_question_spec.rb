require_relative '../features_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks the question', js: true do
    fill_in 'Title', with: 'New question'
    fill_in 'Body', with: 'New question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', 'uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds multiple files when asks the question', js: true do
    fill_in 'Title', with: 'New question'
    fill_in 'Body', with: 'New question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'add attachment'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', 'uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', 'uploads/attachment/file/2/rails_helper.rb'
  end
end
