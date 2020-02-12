class LocalizationsController < ApplicationController
  before_action :set_localization, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :is_admin

  # GET /localizations
  # GET /localizations.json
  def index
    @localizations = Localization.all
  end

  # GET /localizations/1
  # GET /localizations/1.json
  def show
  end

  # GET /localizations/new
  def new
    @localization = Localization.new
  end

  # GET /localizations/1/edit
  def edit
  end

  # POST /localizations
  # POST /localizations.json
  def create
    @localization = Localization.new(localization_params)

    respond_to do |format|
      if @localization.save
        format.html { redirect_to @localization, notice: 'Localization was successfully created.' }
        format.json { render :show, status: :created, location: @localization }
      else
        format.html { render :new }
        format.json { render json: @localization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /localizations/1
  # PATCH/PUT /localizations/1.json
  def update
    respond_to do |format|
      if @localization.update(localization_params)
        format.html { redirect_to @localization, notice: 'Localization was successfully updated.' }
        format.json { render :show, status: :ok, location: @localization }
      else
        format.html { render :edit }
        format.json { render json: @localization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /localizations/1
  # DELETE /localizations/1.json
  def destroy
    @localization.destroy
    respond_to do |format|
      format.html { redirect_to localizations_url, notice: 'Localization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_localization
      @localization = Localization.find(params[:id])
    end

    def is_admin
      authorize Localization
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def localization_params
      params.require(:localization).permit(:localizable_id, :localizable_type, :supported_locale_id, :value)
    end
end
