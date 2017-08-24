class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def unmark_favorites(answer)
    self.answers.where("id != #{answer.id}").each do |a|
      a.update(favorite: false)
    end
  end
end
