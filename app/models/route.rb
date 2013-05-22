class Route < ActiveRecord::Base
  attr_accessible :date, :manager_id, :manager, :route_point_ids, :route_points_attributes
  has_many :route_points, :dependent => :destroy
  belongs_to :manager
  validates :date, :manager, :presence => true 
  accepts_nested_attributes_for :route_points, :allow_destroy => true
  validates :manager_id, :uniqueness => { :scope => :date,
    :message => I18n.t(:one_route_per_date) }
  validate :validate_unique_route_points
    
  def validate_unique_route_points
    validate_uniqueness_of_in_memory(
      route_points, [:shipping_address_id], I18n.t(:dublicate_route_point))
  end
  
end

module ActiveRecord
  class Base
    # Validate that the the objects in +collection+ are unique
    # when compared against all their non-blank +attrs+. If not
    # add +message+ to the base errors.
    def validate_uniqueness_of_in_memory(collection, attrs, message)
      hashes = collection.inject({}) do |hash, record|
        key = attrs.map {|a| record.send(a).to_s }.join
        if key.blank? || record.marked_for_destruction?
          key = record.object_id
        end
        hash[key] = record unless hash[key]
        hash
      end
      if collection.length > hashes.length
        self.errors.add(:base, message)
      end
    end
  end
end