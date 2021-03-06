class Invite < ActiveRecord::Base
  validates :description, presence: true
  validates :key,         length:   { minimum: 16 }, uniqueness: true

  has_many :users

  after_initialize :set_defaults

  def self.key_valid?(key)
    invite = Invite.find_by key: key
    return false unless invite

    invite.users.count < invite.usage
  end

  private
  def set_defaults
    self.key   ||= SecureRandom.base64
    self.usage ||= 1
  end
end
