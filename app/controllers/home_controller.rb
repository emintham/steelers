class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
  end

  def job_landing
    @user = current_user
  end

  def job_redirect
    if params[:type] == "LS"
      redirect_to '/home/new_ls'
    elsif params[:type] == "OTH"
      redirect_to '/home/new_oth'
    else
      flash[:error] = 'Unrecognized job type! Please contact administrator.'
      redirect_to root_url
    end
  end

  def new_ls
    @user = current_user
    @job = Job.new
  end

  def new_oth
    @user = current_user
    @job = Job.new
  end

  def new_upload
    @user = current_user
  end
end
