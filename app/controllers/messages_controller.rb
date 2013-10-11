class MessagesController < ApplicationController
  load_and_authorize_resource
  # GET /messages
  # GET /messages.json
  def index
    @users = User.all
    if current_user.role? :supervisor
      @search = current_user.posted.search(params[:q])
      @messages = @search.result.page(params[:page]).per(current_user.list_page_size)
    elsif current_user.role? :admin
      @search = Message.search(params[:q])
      @messages = @search.result.page(params[:page]).per(current_user.list_page_size)
    end      
    
    @search_inbox = current_user.user_messages.search(params[:q])
    @inboxes = @search_inbox.result.page(params[:page]).per(current_user.list_page_size)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end
  
  # GET /messages/1/read
  # GET /messages/1/read.json
  def read
    @message = Message.find(params[:id])
    @message.read(current_user)
    respond_to do |format|
      format.html # read.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @users = User.all 
    @message = Message.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @users = User.all
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create
    @users = User.all
    params[:message][:user_id] = current_user.id
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: t(:message_created) }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @users = User.all
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: t(:message_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: t(:message_destroyed) }
      format.json { head :no_content }
    end
  end
  
  # POST /messages/multiple_change
  def multiple_change
    if params[:message_ids]
      params[:message_ids].each do |message_id|
        @message = Message.find(message_id)
        @message.destroy
      end
      redirect_to messages_url, notice: t(:messages_removed)      
    else
      redirect_to messages_url
    end
  end
end
