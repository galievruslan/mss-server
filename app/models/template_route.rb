class TemplateRoute < ActiveRecord::Base
  attr_accessible :day_of_week, :manager_id, :manager, :template_route_point_ids, :template_route_points_attributes, :validity
  has_many :template_route_points, :dependent => :destroy
  belongs_to :manager
  validates :day_of_week, :manager, :presence => true
  accepts_nested_attributes_for :template_route_points, :allow_destroy => true
    validates :manager_id, :uniqueness => { :scope => :day_of_week,
    :message => I18n.t(:one_template_route_per_day_of_week) }
  validate :validate_unique_template_route_points
    
  def validate_unique_template_route_points
    validate_uniqueness_of_in_memory(
      template_route_points, [:shipping_address_id], I18n.t(:dublicate_template_route_point))
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