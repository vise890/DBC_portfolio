class Event < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :organizer_name, presence: true
  validates :organizer_email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  validates :date, presence: true
  validate :date_cannot_be_in_the_past, :date_format_must_be_valid


  def date_cannot_be_in_the_past
    if date.present? && date < (Date.today)
      errors.add(:date, 'cannot be in the past')
    end
  end

  def date_format_must_be_valid
#    unless Chronic.parse(date)
#      errors.add(:date, 'must be given in a valid format')
#    end
  end
end
