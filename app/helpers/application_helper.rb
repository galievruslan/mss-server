module ApplicationHelper
  
  # Bootstrap alert message
  def twitterized_type(type)
    case type
      when :alert
        "alert"
      when :error
        "alert alert-error"
      when :notice
        "alert alert-info"
      when :success
        "alert alert-success"
      else
        type.to_s
    end
  end 

end
