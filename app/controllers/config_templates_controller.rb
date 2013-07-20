class ConfigTemplatesController < ApplicationController
  # GET /config_templates
  # GET /config_templates.json
  def index
    @config_templates = ConfigTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @config_templates }
    end
  end

  # GET /config_templates/1
  # GET /config_templates/1.json
  def show
    @config_template = ConfigTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @config_template }
    end
  end

  # GET /config_templates/new
  # GET /config_templates/new.json
  def new
    @config_template = ConfigTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @config_template }
    end
  end

  # GET /config_templates/1/edit
  def edit
    @config_template = ConfigTemplate.find(params[:id])
  end

  # POST /config_templates
  # POST /config_templates.json
  def create
    @config_template = ConfigTemplate.new(params[:config_template])

    respond_to do |format|
      if @config_template.save
        format.html { redirect_to @config_template, notice: 'Config template was successfully created.' }
        format.json { render json: @config_template, status: :created, location: @config_template }
      else
        format.html { render action: "new" }
        format.json { render json: @config_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /config_templates/1
  # PUT /config_templates/1.json
  def update
    @config_template = ConfigTemplate.find(params[:id])

    respond_to do |format|
      if @config_template.update_attributes(params[:config_template])
        format.html { redirect_to @config_template, notice: 'Config template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @config_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /config_templates/1
  # DELETE /config_templates/1.json
  def destroy
    @config_template = ConfigTemplate.find(params[:id])
    filename = @config_template.name.gsub(/ /, '_')
    filepath = Rails.root.join('config_templates', filename).to_s
    if File.exists?(filepath)
      File.delete(filepath)
      Rails.logger.info "<DEV INFO> deleted config_template: #{filename}"
    end
    @config_template.destroy

    respond_to do |format|
      format.html { redirect_to config_templates_url }
      format.json { head :no_content }
    end
  end
end
