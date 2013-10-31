class ValidableModelController < ApplicationController
  
  def multiple_change
    if params[:operation]=='set_valid'
      multiple_valid
    elsif params[:operation]=='set_invalid'
      multiple_invalid
    end
  end
  
  def set_valid
    object = controller_name.classify.constantize.find(params[:id])
    object.set_valid
    respond_to do |format|
      format.html { redirect_to({:controller => controller_name, :action => 'index'}, notice: t(:validity_changed)) }
      format.json { head :no_content }
    end    
  end
  
  def set_invalid
    object = controller_name.classify.constantize.find(params[:id])
    object.set_invalid
    respond_to do |format|
      format.html { redirect_to({:controller=> controller_name, :action => 'index'}, notice: t(:validity_changed)) }
      format.json { head :no_content }
    end    
  end  
    
  def multiple_invalid
    if params[:ids]
      params[:ids].each do |id|
        object = controller_name.classify.constantize.find(id)
        object.set_invalid
      end
      redirect_to({:controller=> controller_name, :action => 'index'}, notice: t(:validity_changed))      
    else
      redirect_to({:controller=> controller_name, :action => 'index'})
    end
  end
  
  def multiple_valid
    if params[:ids]
      params[:ids].each do |id|
        object = controller_name.classify.constantize.find(id)
        object.set_valid
      end
      redirect_to({:controller=> controller_name, :action => 'index'}, notice: t(:validity_changed))      
    else
      redirect_to({:controller=> controller_name, :action => 'index'})
    end
  end
end