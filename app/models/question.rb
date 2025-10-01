class Question < ApplicationRecord
  # Simple integer mapping instead of ActiveRecord::Enum to avoid enum initialization issues.
  PERSONALITIES = {
    0 => "warrior",
    1 => "athlete",
    2 => "artist"
  }.freeze

  validates :text, presence: true
  validates :personality, presence: true
  validates :position, presence: true, numericality: { only_integer: true }

  default_scope { order(:position) }

  def personality_name
    PERSONALITIES[self[:personality].to_i]
  end
end
