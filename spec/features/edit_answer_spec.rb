require_relative 'features_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of the answer
  I want to be able to edit the anwer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: question, user: user) }
  given!(:others_answer) { create(:answer, question: question, user: another_user) }

  scenario 'Unauthenticated user tries to edit the answer' do
    visit question_path question

    expect(page).to_not have_link 'Edit'
  end

  describe "Answer's Author" do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'sees the link to Edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his answer', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit his answer with invalid parameters', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Answer', with: nil
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe "Not answer's author" do
    before do
      sign_in another_user
      visit question_path question
    end

    scenario "tries to edit other's answer" do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe "Question's author" do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'tries to choose the answer as a favorite', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        check 'Favorite'
        click_on 'Save'

        expect(page).to have_content 'Favorite!'
      end
    end

    scenario 'tries to choose two answers as a favorite', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        check 'Favorite'
        click_on 'Save'
      end

      within "#answer-#{second_answer.id}" do
        click_on 'Edit'
        check 'Favorite'
        click_on 'Save'
      end

      within "#answer-#{answer.id}" do
        expect(page).to_not have_content 'Favorite!'
      end

      within "#answer-#{second_answer.id}" do
        expect(page).to have_content 'Favorite!'
      end
    end

    scenario "tries to choose other's answer as a favorite", js: true do
      within "#answer-#{others_answer.id}" do
        click_on 'Edit'
        check 'Favorite'
        click_on 'Save'
        expect(page).to have_content 'Favorite!'
      end
    end
  end

  describe "Not question's author" do
    before do
      sign_in another_user
      visit question_path question
    end

    scenario 'tries to choose the answer as a favorite', js: true do
      within "#answer-#{others_answer.id}" do
        click_on 'Edit'
        expect(page).to_not have_content 'Favorite'
      end
    end
  end

end
