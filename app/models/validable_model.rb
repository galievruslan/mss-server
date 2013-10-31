class ValidableModel < ActiveRecord::Base
  self.abstract_class = true
  
  def set_invalid
    if self.validity
      update_column(:validity, false)
    end
  end
  
  def set_valid
    unless self.validity
      update_column(:validity, true)
    end
  end 

end