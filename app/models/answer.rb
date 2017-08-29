class Answer < ApplicationRecord
  include Attachmentable
  include Votable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :ordered_by_favorite, -> { order(favorite: :desc) }

  def mark_favorite
    ActiveRecord::Base.transaction do
      question.answers.where("id != #{self.id}").each do |a|
        a.update!(favorite: false)
      end

      self.update!(favorite: true)
    end
  end
end
