class Answer < ApplicationRecord
  include Attachmentable
  include Votable
  include Commentable

  after_create :send_question_updates

  belongs_to :question, touch: true
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

  private

  def send_question_updates
    QuestionUpdateJob.perform_later(self)
  end
end
