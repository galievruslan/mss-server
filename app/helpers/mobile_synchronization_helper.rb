module MobileSynchronizationHelper
  def page_size
    if params[:page_size]
      page_size = params[:page_size]
    else
      page_size = 100
    end
    return page_size
  end
  def page
    if params[:page]
      page = params[:page]
    end
    return page
  end
end
