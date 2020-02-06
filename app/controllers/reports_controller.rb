class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_products, only: [:new, :edit, :create, :update]
  before_action :set_lat_long, only: [:new, :edit]

  # GET /reports
  # GET /reports.json
  def index
    authorize Report
    @reports = policy_scope(Report)
    @users = @reports.map { |report| report.user_id }.uniq
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    authorize @report
  end

  # GET /reports/new
  def new
    authorize Report

    @report = Report.new(coordinates: "POINT(#{@long} #{@lat})")
    @report.product_detail.build(scarcity: 1, price: 1)
  end

  # GET /reports/1/edit
  def edit
    authorize @report
  end

  # POST /reports
  # POST /reports.json
  def create
    authorize Report

    passed_params = report_params

    # Create a mutable version of the params.
    augmented_params = passed_params.except(:lat, :long)

    # Augment the parameters with server-known information.
    augmented_params["ip"] = request.remote_ip
    augmented_params["user_id"] = current_user.id

    # Construct the actual WKT.
    augmented_params["coordinates"] = "POINT(#{passed_params["long"]} #{passed_params["lat"]})"

    @report = Report.new(augmented_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    authorize @report

    passed_params = report_params

    # Create a mutable version of the params.
    augmented_params = passed_params.except(:lat, :long)

    # Construct the actual WKT.
    augmented_params["coordinates"] = "POINT(#{passed_params["long"]} #{passed_params["lat"]})"

    respond_to do |format|
      if @report.update(augmented_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    authorize @report

    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    def set_products
      @products = Product.all
    end

    def set_lat_long
      @lat = params["lat"]
      @long = params["long"]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(
        :notes,
        :lat,
        :long,
        product_detail_attributes: [
          :id,
          :scarcity,
          :price,
          :notes,
          :product_id,
          :_destroy
        ]
      )
    end
end
