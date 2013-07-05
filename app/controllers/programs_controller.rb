class ProgramsController < ApplicationController
  def show
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @program }
    end
  end

  def index
    @programs = Program.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @programs }
    end
  end

  def create
    @program = Program.new(params[:name])
    if @program.save
       redirect_to @program, :notice => "Added program!"
    else
       render "new"
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def new
    @program = Program.new
  end

end
