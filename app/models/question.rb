class Question < ApplicationRecord
  include Attachmentable
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
