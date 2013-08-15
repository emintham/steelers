class UserfilesController < ApplicationController
#  # GET /userfiles
#  # GET /userfiles.json
#  def index
#    @user = User.find(params[:user_id])
#    @userfiles = @user.userfiles.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render json: @userfiles }
#    end
#  end

  # GET /userfiles/1
  # GET /userfiles/1.json
  def show
    @user = User.find(params[:user_id])
    @userfile = @user.userfiles.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @userfile }
    end
  end

  # GET /userfiles/new
  # GET /userfiles/new.json
  def new
    @user = User.find(params[:user_id])
    @userfile = @user.userfiles.new
  end

  # GET /userfiles/1/edit
  def edit
    @user = User.find(params[:user_id])
    @userfile = @user.userfiles.find(params[:id])
  end

  # POST /userfiles
  # POST /userfiles.json
  def create
    @user = User.find(params[:user_id])
    @userfile = @user.userfiles.create(params[:userfile])

    if !@userfile.valid_format?
      File.delete(@userfile.upload.path) if File.exists?(@userfile.upload.path)
      @userfile.destroy
      flash[:error] = 'Invalid format!'
    elsif @userfile.save
      flash[:notice] = "File uploaded successfully!"
    else
      flash[:error] = 'Problem with uploading file. Please make sure the selected file exists.'
    end
    redirect_to root_url
  end

  # PUT /userfiles/1
  # PUT /userfiles/1.json
  def update
    @user = User.find(params[:user_id])
    @userfile = @user.userfiles.find(params[:id])

    respond_to do |format|
      if @userfile.update_attributes(params[:userfile])
        format.html { redirect_to root_url, notice: 'File was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /userfiles/1
  # DELETE /userfiles/1.json
  def destroy
    @user = User.find(params[:user_id])
    @userfile = @user.userfiles.find(params[:id])
    File.delete(@userfile.upload.path) if File.exists?(@userfile.upload.path)
    @userfile.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'File deleted.' }
    end
  end

  def import
    @user = User.find(params[:user_id])
    @userfile = @user.userfiles.find(params[:id])
    if @userfile.import(@userfile.type_id)
      flash[:notice] = "Import completed successfully!"
    else
      flash[:error] = "Problems with importing configuration file. Please see wiki for more information about uploading."
    end
    redirect_to root_url
  end
end
