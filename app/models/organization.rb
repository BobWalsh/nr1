# == Schema Information
#
# Table name: organizations
#
#  id   :integer          not null, primary key
#  name :string
#

class Organization < ApplicationRecord
  has_many :events, dependent: :destroy
end
