class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :timestamp, :user_id, :user
  validates :latitude, :longitude, :timestamp, :user, :presence => true
  belongs_to :user
  validates :timestamp, :uniqueness => { :scope => :user_id,
    :message => I18n.t(:one_timestamp_location_per_user) }
  acts_as_gmappable
end
