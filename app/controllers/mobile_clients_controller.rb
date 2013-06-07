class MobileClientsController < ApplicationController
  require 'fileutils'
  require 'zip/zip'
  
  load_and_authorize_resource
  # GET /mobile_clients
  # GET /mobile_clients.json
  def index    
    @search = MobileClient.search(params[:q])    
    @mobile_clients = @search.result.page(params[:page]).per(current_user.list_page_size)
    @client_types = ['Android', 'WinMobile']
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mobile_clients }
    end
  end

  # GET /mobile_clients/1
  # GET /mobile_clients/1.json
  def show
    @mobile_client = MobileClient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mobile_client }
    end
  end

  # GET /mobile_clients/new
  # GET /mobile_clients/new.json
  def new
    @mobile_client = MobileClient.new
    @client_types = ['Android', 'WinMobile']

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mobile_client }
    end
  end

  # GET /mobile_clients/1/edit
  def edit
    @mobile_client = MobileClient.find(params[:id])
    @client_types = ['Android', 'WinMobile']
  end

  # POST /mobile_clients
  # POST /mobile_clients.json
  def create    
    @client_types = ['Android', 'WinMobile']
    
    if params[:mobile_client][:file] and !params[:mobile_client][:client_type].blank?
      date = Time.now.strftime('%H%M%S-%d%m%y')          
      if params[:mobile_client][:client_type] == 'Android'
        directory = "public/mobile_clients/android"
        zipfile_name = "public/mobile_clients/android/" + date + ".zip"
        link = "mobile_clients/android/" + date + ".zip"
        filename = 'MSS.Android.apk'
      elsif params[:mobile_client][:client_type] == 'WinMobile'
        directory = "public/mobile_clients/winmobile"
        zipfile_name = "public/mobile_clients/winmobile/" + date + ".zip"
        link = "mobile_clients/winmobile/" + date + ".zip"
        filename = 'MSS.WinMobile.CAB'
      end
      tmp = params[:mobile_client][:file].tempfile
      
      Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
        zipfile.add(filename, tmp.path)
      end
      
      # file = File.join(directory, filename)
      # FileUtils.cp tmp.path, file      
      params[:mobile_client][:file] = link
    end
    
    @mobile_client = MobileClient.new(params[:mobile_client])
    
    respond_to do |format|
      if @mobile_client.save
        format.html { redirect_to @mobile_client, notice: t(:mobile_client_created) }
        format.json { render json: @mobile_client, status: :created, location: @mobile_client }
      else
        format.html { render action: "new" }
        format.json { render json: @mobile_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mobile_clients/1
  # PUT /mobile_clients/1.json
  def update
    @mobile_client = MobileClient.find(params[:id])
    @client_types = ['Android', 'WinMobile']
    
    if params[:mobile_client][:file] and !params[:mobile_client][:client_type].blank?      
      
      filename = @mobile_client.file
      if File.exists?(Rails.root + 'public/' + filename)
        File.delete(Rails.root + 'public/' + filename)
      end
      
      date = Time.now.strftime('%H%M%S-%d%m%y')          
      if params[:mobile_client][:client_type] == 'Android'
        directory = "public/mobile_clients/android"
        zipfile_name = "public/mobile_clients/android/" + date + ".zip"
        link = "mobile_clients/android/" + date + ".zip"
        filename = 'MSS.Android.apk'
      elsif params[:mobile_client][:client_type] == 'WinMobile'
        directory = "public/mobile_clients/winmobile"
        zipfile_name = "public/mobile_clients/winmobile/" + date + ".zip"
        link = "mobile_clients/winmobile/" + date + ".zip"
        filename = 'MSS.WinMobile.CAB'
      end
      tmp = params[:mobile_client][:file].tempfile
      
      Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
        zipfile.add(filename, tmp.path)
      end
          
      params[:mobile_client][:file] = link
    end    

    respond_to do |format|
      if @mobile_client.update_attributes(params[:mobile_client])
        format.html { redirect_to @mobile_client, notice: t(:mobile_client_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mobile_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mobile_clients/1
  # DELETE /mobile_clients/1.json
  def destroy
    @mobile_client = MobileClient.find(params[:id])
    
    filename = @mobile_client.file
    if File.exists?(Rails.root + 'public/' + filename)
      File.delete(Rails.root + 'public/' + filename)
    end
    @mobile_client.destroy

    respond_to do |format|
      format.html { redirect_to mobile_clients_url, notice: t(:mobile_client_destroyed) }
      format.json { head :no_content }
    end
  end
end
