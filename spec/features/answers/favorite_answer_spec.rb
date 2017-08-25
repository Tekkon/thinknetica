require_relative '../features_helper'

feature 'Choosing favorite answer', %q{
  In order to tell the users what answer is good for me
  As an author of the question
  I want to choose a favorite answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: question, user: user) }
  given!(:others_answer) { create(:answer, question: question, user: another_user) }

  describe "Question's author" do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'tries to choose his answer as a favorite', js: true do
      within "#answer-#{answer.id}" do
        choose "rb[favorite]"
        wait_for_ajax
        expect(find_field("rb[favorite]")).to be_checked
      end
    end

    scenario "tries to choose other's answer as a favorite", js: true do
      within "#answer-#{others_answer.id}" do
        choose "rb[favorite]"
        wait_for_ajax
        expect(find_field("rb[favorite]")).to be_checked
      end
    end

    scenario 'tries to choose two answers as a favorite', js: true do
      within "#answer-#{answer.id}" do
        choose "rb[favorite]"
      end

      wait_for_ajax

      within "#answer-#{second_answer.id}" do
        choose "rb[favorite]"
      end

      wait_for_ajax

      within "#answer-#{answer.id}" do
        expect(find_field("rb[favorite]")).to_not be_checked
      end

      within "#answer-#{second_answer.id}" do
        expect(find_field("rb[favorite]" )).to be_checked
      end

      expect(second_answer.body).to appear_before(answer.body)
      expect(second_answer.body).to appear_before(others_answer.body)
    end
  end

  describe "Not question's author" do
    before do
      sign_in another_user
      visit question_path question
    end

    scenario 'tries to choose the answer as a favorite', js: true do
      within ".answers" do
        expect(page).to_not have_field 'rb[favorite]'
      end
    end
  end

end
