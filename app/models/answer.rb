class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def mark_favorite
    self.update(favorite: true)
    self.question.unmark_favorites(self)
  end
end
