class ServersController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @server = Server.new  
  end

  def create
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @server = Server.create(params[:server])
    if @server.save
      flash[:notice] = "Server successfully added!"
    else
      flash[:error] = "Error creating server!"
    end
    redirect_to 'admins#index'
  end

  def destroy
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @server = Server.find(params[:id])
    @server.destroy
    flash[:notice] = "Server deleted!"
    redirect_to 'admins#index'
  end
end
