class User < ActiveRecord::Base

  include BCrypt

  validate :name, presence: true
  validate :email, presence: true, uniqueness: true

  def self.authenticate(email, password)

    user = User.find_by_email(email)

    if user && user.password == password
      return user
    else
      return nil
    end

  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

end
