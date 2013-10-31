class Status < ValidableModel
  attr_accessible :name, :route_point_ids, :validity
  has_many :route_points, :dependent => :destroy
  validates :name, :presence => true
  validates :name, :uniqueness => { :case_sensitive => false }
end
