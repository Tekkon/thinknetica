require_relative '../features_helper'

feature 'Question voting', %q{
  In order to choose a question that I like
  As authenticated user
  I want to be able to vote for question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) }
  given!(:vote) { create(:vote, user: another_user, votable: questions[1], votable_type: 'Question', vote_type: 1) }

  context 'Not author of the question' do
    before do
      sign_in(another_user)
      visit question_path(questions[0])
    end

    scenario 'votes for question', js: true do
      choose "rb_vote_question_#{questions[0].id}_1"

      within "#question-#{questions[0].id}" do
        expect(page).to have_content 'You have voted for this question.'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'votes against question', js: true do
      choose "rb_vote_question_#{questions[0].id}_0"

      within "#question-#{questions[0].id}" do
        expect(page).to have_content 'You have voted against this question.'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'can vote for or against question only one time', js: true do
      choose "rb_vote_question_#{questions[0].id}_1"

      within "#question-#{questions[0].id}" do
        expect(page).to_not have_content 'Vote for'
        expect(page).to_not have_content 'Vote against'
      end
    end

    scenario 'can revote for or against question', js: true do
      visit question_path(questions[1])

      within "#question-#{questions[1].id}" do
        click_on 'Revote'
        expect(page).to have_content 'Rating: 0'

        choose "rb_vote_question_#{questions[1].id}_1"
        expect(page).to have_content 'You have voted for this question.'
        expect(page).to have_content 'Rating: 1'
      end
    end
  end

  context 'Author of the question' do
    before do
      sign_in(user)
      visit question_path(questions[0])
    end

    scenario 'tries to vote for his question' do
      expect(page).to_not have_content 'Vote for'
      expect(page).to_not have_content 'Vote against'
    end
  end

  context 'Unauthorized user' do
    scenario 'tries to vote for question' do
      visit question_path(questions[0])
      expect(page).to_not have_content 'Vote for'
      expect(page).to_not have_content 'Vote against'
    end
  end

  scenario 'Any user sees the rating of the question' do
    visit question_path(questions[0])

    within "#question-#{questions[0].id}" do
      expect(page).to have_content('Rating')
    end
  end

end
