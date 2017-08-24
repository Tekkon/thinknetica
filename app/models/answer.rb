class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :ordered_by_favorite, -> { order(favorite: :desc) }

  def mark_favorite
    self.update(favorite: true)
    self.question.unmark_favorites(self)
  end
end
