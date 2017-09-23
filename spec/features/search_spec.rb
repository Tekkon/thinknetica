require_relative './features_helper'
require 'sphinx_helper'

feature 'Search question', %q{
  In order to find information
  As an user
  I want to search a question
} do

  given!(:question) { create(:question, title: 'new', body: 'new') }
  given!(:answer) { create(:answer, body: 'new', question: question) }
  given!(:comment) { create(:comment, body: 'new', commentable: question) }
  given!(:user) { create(:user, email: 'new@email.com') }

  background do
    index
    visit questions_path
  end

  ThinkingSphinx::Test.run do
    %w(Question Answer Comment User).each do |object|
      scenario "User finds #{object}", js: true do
        select object
        fill_in 'Text', with: 'new'
        click_on 'Search'
        content = object == 'User' ? 'new@email.com' : 'new'
        expect(page).to have_content object
        expect(page).to have_content content
      end
    end

    scenario 'User find all objects', js: true do
      select 'All'
      fill_in 'Text', with: 'new'
      click_on 'Search'

      %w(Question Answer Comment User).each do |object|
        expect(page).to have_content object
      end
    end
  end

end
