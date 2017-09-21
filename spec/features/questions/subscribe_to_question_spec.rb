require_relative '../features_helper'

feature 'Subscribe to question', %q{
  In order to get updates on question
  As an user
  I want to subscribe to question
} do

  given!(:question) { create(:question) }
  given(:user) { create(:user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit questions_path
    end

    context 'is not subscribed to question yet' do
      scenario 'sees the Subscribe link' do
        expect(page).to have_content 'Subscribe'
      end

      scenario "doesn't see the Unsubscribe link" do
        expect(page).to_not have_content 'Unsubscribe'
      end

      scenario 'subscribes to question', js: true do
        click_on 'Subscribe'
        expect(page).to have_content 'Unsubscribe'
        expect(page).to_not have_content 'Subscribe'
      end
    end

    context 'is subscribed already' do
      given!(:subsctiption) { create(:subscription, user: user, question: question) }
      before { visit questions_path }

      scenario 'sees the Subscribe link' do
        expect(page).to_not have_content 'Subscribe'
      end

      scenario "doesn't see the Unsubscribe link" do
        expect(page).to have_content 'Unsubscribe'
      end

      scenario 'unsubscribes from question', js: true do
        click_on 'Unsubscribe'
        expect(page).to_not have_content 'Unsubscribe'
        expect(page).to have_content 'Subscribe'
      end
    end
  end

  context 'Not authenticated user' do
    scenario "doesn't see the Subscribe link" do
      visit questions_path
      expect(page).to_not have_content 'Subscribe'
    end

    scenario "doesn't see the Unsubscribe link" do
      visit questions_path
      expect(page).to_not have_content 'Unsubscribe'
    end
  end

end
