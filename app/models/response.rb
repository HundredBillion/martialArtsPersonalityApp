class Response < ApplicationRecord
  belongs_to :submission
  belongs_to :question

  validates :value, inclusion: { in: [0, 1, 2] }
end
