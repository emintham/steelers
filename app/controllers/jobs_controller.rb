class JobsController < ApplicationController
  def show
     @job = Job.find(params[:id])
     authorize! :read, @job
  end

  def index
     @jobs = Job.all
  end

  def create
     @user = User.find(params[:user_id])
     @job = @user.jobs.create(params[:job])
     redirect_to root_url, :alert => 'Job created successfully!'
  end

  def destroy
     @user = User.find(params[:user_id])
     @job = @user.jobs.find(params[:id])

     # insert code to verify job completion
     # maybe terminate job...

     @job.destroy
     redirect_to root_url, :alert => 'Job deleted.'
  end

  def new
     @user = User.find(params[:user_id])
     @job = Job.new(:user_id => params[:user_id])
  end

  def start
     @job = Job.find(params[:id])
     @job.output = '' # default of no output name

     # insert code to start background job here
  end
end
