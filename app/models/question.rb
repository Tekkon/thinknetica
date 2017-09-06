class Question < ApplicationRecord
  include Attachmentable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
