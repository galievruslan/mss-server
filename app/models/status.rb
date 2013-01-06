class Status < ActiveRecord::Base
  attr_accessible :name
  belongs_to :route_point
end
