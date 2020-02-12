class SupportedLocalesController < ApplicationController
  before_action :set_supported_locale, only: [:show, :edit, :update, :destroy]

  # GET /supported_locales
  # GET /supported_locales.json
  def index
    @supported_locales = SupportedLocale.all
  end

  # GET /supported_locales/1
  # GET /supported_locales/1.json
  def show
  end

  # GET /supported_locales/new
  def new
    @supported_locale = SupportedLocale.new
  end

  # GET /supported_locales/1/edit
  def edit
  end

  # POST /supported_locales
  # POST /supported_locales.json
  def create
    @supported_locale = SupportedLocale.new(supported_locale_params)

    respond_to do |format|
      if @supported_locale.save
        format.html { redirect_to @supported_locale, notice: 'Supported locale was successfully created.' }
        format.json { render :show, status: :created, location: @supported_locale }
      else
        format.html { render :new }
        format.json { render json: @supported_locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supported_locales/1
  # PATCH/PUT /supported_locales/1.json
  def update
    respond_to do |format|
      if @supported_locale.update(supported_locale_params)
        format.html { redirect_to @supported_locale, notice: 'Supported locale was successfully updated.' }
        format.json { render :show, status: :ok, location: @supported_locale }
      else
        format.html { render :edit }
        format.json { render json: @supported_locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supported_locales/1
  # DELETE /supported_locales/1.json
  def destroy
    @supported_locale.destroy
    respond_to do |format|
      format.html { redirect_to supported_locales_url, notice: 'Supported locale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supported_locale
      @supported_locale = SupportedLocale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supported_locale_params
      params.require(:supported_locale).permit(:name)
    end
end
