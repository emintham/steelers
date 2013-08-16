class ServersController < ApplicationController
  def new
    @server = Server.new  
  end

  def create
    @server = Server.create(params[:server])
    if @server.save
      flash[:notice] = "Server successfully added!"
    else
      flash[:error] = "Error creating server!"
    end
    redirect_to 'admins#index'
  end

  def destroy
    @server = Server.find(params[:id])
    @server.destroy
    flash[:notice] = "Server deleted!"
    redirect_to 'admins#index'
  end
end
