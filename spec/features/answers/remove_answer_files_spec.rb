require_relative '../features_helper'

feature 'Removing files', %q{
  In order to illustrate ny question
  As an quthor of the question
  I want to delete attachment
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment, attachmentable: answer, file: Rails.root.join("spec/spec_helper.rb").open) }

  context "Answer's author" do
    before do
      sign_in(user)
      visit question_path question
    end

    scenario 'removes file from his question', js: true do
      within "#answer-#{answer.id}-attachments" do
        click_on 'remove'
      end

      expect(current_path).to eq question_path(question)

      within "#answer-#{answer.id}-attachments" do
        expect(page).to_not have_link 'spec_helper.rb', 'uploads/attachemnt/file/1/spec_helper.rb'
      end
    end
  end

  context "Not answers's author" do
    before do
      sign_in(another_user)
      visit question_path question
    end

    scenario "tries to remove file from other's question" do
      within "#answer-#{answer.id}-attachments" do
        expect(page).to_not have_link 'remove'
      end
    end
  end

end
