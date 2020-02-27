
class BotController < ApplicationController

  skip_before_action :verify_authenticity_token

  # POST /bot_report
  def create_bot_report

    if request.headers["X-Telegram-Bot-Key"] != ENV["TELEGRAM_BOT_SECRET"]
      return head :unauthorized
    end


    passed_params = params.require(:report).permit(
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

    # Create a mutable version of the params.
    augmented_params = passed_params.except(:lat, :long).to_hash

    # Augment the parameters with server-known information.
    augmented_params["ip"] = request.remote_ip
    augmented_params["geo_ip"] = get_geo_ip(request.remote_ip)
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

end
