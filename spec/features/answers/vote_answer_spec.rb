require_relative '../features_helper'

feature 'Answer voting', %q{
  In order to choose an answer that I like
  As authenticated user
  I want to be able to vote for answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, user: user, question: question) }
  given!(:vote) { create(:vote, user: another_user, votable: answers[1], votable_type: 'Answer', vote_type: 1) }

  context 'Not author of the answer' do
    before do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'votes for answer', js: true do
      choose "rb_vote_answer_#{answers[0].id}_1"

      within "#answer-#{answers[0].id}" do
        expect(page).to have_content 'You have voted for this answer.'
      end
    end

    scenario 'votes against answer', js: true do
      choose "rb_vote_answer_#{answers[0].id}_0"

      within "#answer-#{answers[0].id}" do
        expect(page).to have_content 'You have voted against this answer.'
      end
    end

    scenario 'can vote for or against answer only one time', js: true do
      choose "rb_vote_answer_#{answers[0].id}_1"

      within "#answer-#{answers[0].id}" do
        expect(page).to_not have_content 'Vote for'
        expect(page).to_not have_content 'Vote against'
      end
    end

    scenario 'can revote for or against answer', js: true do
      within "#answer-#{answers[1].id}" do
        click_on 'Revote'
        choose "rb_vote_answer_#{answers[1].id}_1"
        expect(page).to have_content 'You have voted for this answer.'
      end
    end
  end

  context 'Author of the answer' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to vote for his answer' do
      expect(page).to_not have_content 'Vote for'
      expect(page).to_not have_content 'Vote against'
    end
  end

  context 'Unauthorized user' do
    scenario 'tries to vote for answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Vote for'
      expect(page).to_not have_content 'Vote against'
    end
  end

  scenario 'Any user sees the rating of the answer' do
    visit question_path(question)

    within "#answer-#{answers[0].id}" do
      expect(page).to have_content('Rating')
    end

    within "#answer-#{answers[1].id}" do
      expect(page).to have_content('Rating')
    end
  end

end
