class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

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
