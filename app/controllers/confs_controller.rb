class ConfsController < ApplicationController
  # GET /confs
  # GET /confs.json
  def index
    @user = User.find(params[:user_id])
    @confs = @user.confs.all
  end

  # GET /confs/1
  # GET /confs/1.json
  def show
    @user = User.find(params[:user_id])
    @conf = @user.confs.find(params[:id])
  end

  # GET /confs/new
  # GET /confs/new.json
  def new
    @user = User.find(params[:user_id])
    @conf = @user.confs.new(config_template_id: params[:config_template_id])

    respond_to do |format|
      redirect_to root_url
    end
  end

  # GET /confs/1/edit
  def edit
    @user = User.find(params[:user_id])
    @conf = @user.confs.find(params[:id])
  end

  # POST /confs
  # POST /confs.json
  def create
    @user = User.find(params[:user_id])
    @conf = @user.confs.new(params[:conf])

    respond_to do |format|
      if @conf.save
        format.html { redirect_to root_url, notice: 'Conf was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /confs/1
  # PUT /confs/1.json
  def update
    @user = User.find(params[:user_id])
    @conf = @user.confs.find(params[:id])

    respond_to do |format|
      if @conf.update_attributes(params[:conf])
        @conf.write_to_file     # write changes to file
        format.html { redirect_to root_url, notice: 'Conf was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /confs/1
  # DELETE /confs/1.json
  def destroy
    @user = User.find(params[:user_id])
    @conf = @user.confs.find(params[:id])
    filename = @conf.name.gsub(/ /, '_') + @conf.id.to_s
    filepath = Rails.root.join('confs', @user.id.to_s, filename).to_s
    if File.exists?(filepath)
      File.delete(filepath)
      Rails.logger.info "<DEV INFO> deleted conf: #{filename}"
    end
    @conf.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end
end
