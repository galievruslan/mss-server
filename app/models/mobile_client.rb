class MobileClient < ActiveRecord::Base
  attr_accessible :file, :client_type, :version
  validates :file, :client_type, :version, :presence => true
  validates :version, :uniqueness => { :scope => :client_type,
    :message => I18n.t(:one_version_per_type), :case_sensitive => false }  
end
