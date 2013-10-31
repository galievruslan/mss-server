class ManagerWarehouse < ValidableModel
  attr_accessible :manager_id, :warehouse_id, :manager, :warehouse, :validity
  belongs_to :manager
  belongs_to :warehouse
  validates :manager, :warehouse, :presence => true
  validates :warehouse_id, :uniqueness => { :scope => :manager_id,
    :message => I18n.t(:one_warehouse_per_manager) }
end
