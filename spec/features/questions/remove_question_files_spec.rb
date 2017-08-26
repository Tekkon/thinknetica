require_relative '../features_helper'

feature 'Removing files', %q{
  In order to illustrate ny question
  As an quthor of the question
  I want to delete attachment
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachmentable: question, file: Rails.root.join("spec/spec_helper.rb").open) }

  context "Question's author" do
    before do
      sign_in(user)
      visit question_path question
    end

    scenario 'removes file from his question', js: true do
      within '#question_attachments' do
        click_on 'remove'
      end

      expect(current_path).to eq question_path(question)
      within '#question_attachments' do
        expect(page).to_not have_link 'spec_helper.rb', 'uploads/attachemnt/file/1/spec_helper.rb'
      end
    end
  end

  context "Not question's author" do
    before do
      sign_in(another_user)
      visit question_path question
    end

    scenario "tries to remove file from other's question" do
      within '#question_attachments' do
        expect(page).to_not have_link 'remove'
      end
    end
  end

end