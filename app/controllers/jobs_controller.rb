class JobsController < ApplicationController
  def show
    @job = Job.find(params[:id])
    authorize! :read, @job
  end

  def create
    @user = User.find(params[:user_id])
    @job = Job.new(params[:job])
    @job.user_id = params[:user_id]

    if @job.save
       flash[:notice] = "Job created successfully!"
       if @job.status
          flash[:notice] = 'Starting job now...'
          @job.run
          flash[:notice] = 'Job completed!'
       else
          flash[:notice] = 'Job saved for later...'
       end
       redirect_to root_url
    else
       render "new"
    end
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
    @job = Job.new  
  end

  def run
    @user = User.find(params[:user_id])
    @job = @user.jobs.find(params[:id])
    flash[:notice] = 'Starting job now...'
    if @job.run
      flash[:notice] = 'Success.'
    else
      flash[:error] = "Error."
    end
    redirect_to root_url
  end
end
