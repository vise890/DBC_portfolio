class Skill < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :proficiencies
  has_many :users, through: :proficiencies

  def user_with_proficiency(rating)
    self.proficiencies.each do |proficiency|
      if proficiency.proficiency_rating == rating
        return proficiency.user
      end
    end
    return nil
  end
end
