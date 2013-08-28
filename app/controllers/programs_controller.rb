class ProgramsController < ApplicationController
  before_filter :authenticate_user!

  def show
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @program }
    end
  end

  def index
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @programs = Program.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @programs }
    end
  end

  def create
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @program = Program.new(params[:name])
    if @program.save
       redirect_to @program, :notice => "Added program!"
    else
       render "new"
    end
  end

  def destroy
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to admins_path }
      format.json { head :no_content }
    end
  end

  def new
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @program = Program.new
  end

  def toggle
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @program = Program.find(params[:id])
    if @program.toggle
      flash[:notice] = "Successfully toggled #{@program.name}'s folder specificity!"
    else
      flash[:error] = "An error occurred."
    end
    redirect_to admins_path
  end

  def change_type
    authorize! :index, @user, :message => 'Not authorized as administrator.'
    @program = Program.find(params[:id])
    if @program.change_type
      flash[:notice] = "Successfully changed #{@program.name}'s type!"
    else
      flash[:error] = "An error occurred."
    end
    redirect_to admins_path
  end
end
