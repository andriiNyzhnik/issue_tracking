class Customer < ActiveRecord::Base
  has_many :tickets
  has_many :replies, as: :repliable

  validates_presence_of :name
  validates :email, presence: true, format: { with: /\A(?:[^@\s]+)@(?:[-a-z0-9]+\.)+[a-z]{2,}\z/i }
  validates_uniqueness_of :email
end

# == Schema Information
#
# Table name: customers
#
#  id                            :integer          not null, primary key
#  name                          :string(255)
#  email                         :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
