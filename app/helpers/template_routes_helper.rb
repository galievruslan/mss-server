module TemplateRoutesHelper
  def day_name(day_of_week)
    case day_of_week
    when 0
      return 'Sunday'    
    when 1
      return 'Monday'    
    when 2
      return 'Tuesday'    
    when 3
      return 'Wednesday'    
    when 4
      return 'Thursday'      
    when 5
      return 'Friday'       
    when 6
      return 'Saturday'
    end  
  end
end
