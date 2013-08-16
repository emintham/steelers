class AdminsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
    @user = current_user
    @servers = Server.all
    @config_templates = ConfigTemplate.all
    @programs = Program.all
  end
end
