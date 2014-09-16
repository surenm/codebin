class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :trackable, :validatable, :omniauthable, :timeoutable

  has_many :snippets

  def self.find_by_email(email)
    user = User.where(:email => email).first
  end

  def self.user_exists?(email)
    User.where(:email => email).exists?
  end

  def self.find_or_create_user(access_token)
    data = access_token.info

    if user_exists? data["email"]
      user = User.find_by_email data["email"]
    else
      user = User.create! email: data["email"], name: data["name"], nick: data["nickname"], dp: data["image"],
                          password: Devise.friendly_token[0,20]
    end

    return user
  end
end
