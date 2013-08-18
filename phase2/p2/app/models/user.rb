class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :proficiencies
  has_many :skills, through: :proficiencies

  def proficiency_for(skill)
    self.proficiencies do |proficiency|
      return proficiency.proficiency_rating if proficiency.skill == skill
    end
    return 0
  end

  def set_proficiency_for(skill, proficiency_rating)
    self.proficiencies.each do |proficiency|
      if proficiency.skill == skill
        proficiency.proficiency_rating = proficiency_rating
        proficiency.save
        break
      end
    end
  end
end
