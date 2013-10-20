class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!, :only => [:edit, :update]

  # GET /images/key
  # GET /images/key.json
  def show
    @permissions = {
      :edit => (user_signed_in? && @image.is_owned_by_user?(current_user))
    }
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/key/edit
  def edit
    @image = Image.find_by_key(params[:key])

    if current_user.id != @image.user_id
      redirect_to @image, alert: "Can't edit images that aren't your own."
    end
  end

  # POST /images
  # POST /images.json
  def create
    if image_params[:file].nil?
      return render action: 'new', notice: 'Upload failed.'
    end

    image_params[:file].each do |file|
      image = { file: file }
      @image = current_user.images.new(image)
      break unless @image.save
    end

    respond_to do |format|
      unless @image.new_record?
        format.html { redirect_to @image, notice: 'Image(s) uploaded successfully.' }
        format.json { render action: 'show', status: :created, location: @image }
      else
        format.html { render action: 'new', notice: 'Upload failed.' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /images/editsubmit
  def edit_submit
    render text: 'Hello there'
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if current_user.id != @image.user_id
        error_msg = "Can't edit images that aren't your own."
        format.html { redirect_to @image, notice: error_msg }
        format.json { render :json => { :errors => error_msg } }
      end

      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find_by(key: params[:key])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params[:image].permit(:file, { file: [] }, :description)
    end
end
