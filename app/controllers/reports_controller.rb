class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_products, only: [:new, :edit, :create, :update]
  before_action :set_lat_long, only: [:new, :edit, :create_bot_report]
  before_action :authenticate_user!, except: [:create_bot_report]

  skip_before_action :verify_authenticity_token, only: [:create_bot_report]


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

    handle_report_submission

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

  def create_bot_report
     if request.headers["X-Telegram-Bot-Key"] != ENV["TELEGRAM_BOT_SECRET"]
      return head :unauthorized
    end

    handle_report_submission

    respond_to do |format|
      if @report.save
        format.json { render :show, status: :created, location: @report }
      else
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
    augmented_params = passed_params.except(:lat, :long).to_hash

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
      @report = Report.includes(product_detail: { product: :localization }).find(params[:id])
    end

    def set_products
      @products = Product.includes(:localization).all
    end

    def set_lat_long
      @lat = params["lat"]
      @long = params["long"]
    end

    def get_geo_ip(ip)
      results = {}
      city = $geoip_city.get(ip)
      asn = $geoip_asn.get(ip)

      if !city.nil?
        results = results.merge(city)
      end

      if !asn.nil?
        results["asn"] = asn
      end

      return walk(results)
    end

    def walk(thing)
      if (!thing.is_a?(Hash) && !thing.is_a?(Array))
        return thing
      end

      if thing.is_a?(Hash) && thing.has_key?("names")
        if (thing["names"].has_key?("en"))
          thing["names"] = { "en": thing["names"]["en"] }
        end
      end

      thing.each {|key, value| walk(value || key)}

      return thing
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

    def handle_report_submission
      passed_params = report_params

      # Create a mutable version of the params.
      augmented_params = passed_params.except(:lat, :long).to_hash

      # Augment the parameters with server-known information.
      augmented_params["ip"] = request.remote_ip
      augmented_params["geo_ip"] = get_geo_ip(request.remote_ip)

      if current_user&.id?
        augmented_params["user_id"] = current_user&.id
      else
        u = User.find_or_create_by(email: "bot@osinthk.org")
        u.save(validate: false)
        augmented_params["user_id"] = u.id
      end

      puts "hello! #{augmented_params["user_id"]}, #{u}"

      # Construct the actual WKT.
      augmented_params["coordinates"] = "POINT(#{passed_params["long"]} #{passed_params["lat"]})"

      @report = Report.new(augmented_params)
    end
end
