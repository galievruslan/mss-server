module ApplicationHelper
  def twitterized_type(type)
  case type
    when :alert
      "alert alert-error"
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
