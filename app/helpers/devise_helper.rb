module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    # sentence = I18n.t("errors.title")

    html = <<-HTML
    <div class="alert alert-error">
      <button type="button" class="close" data-dismiss="alert">&times;</button>      
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end