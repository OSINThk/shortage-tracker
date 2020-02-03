class MapsController < ApplicationController
  def index
  end

  def results
    @results = Report.includes(product_detail: :product).all

    # @sql = ActiveRecord::Base.send(:sanitize_sql_array, [
    #   "SELECT
    #     p.id, p.name,
    #     COUNT(*) AS live_reports,
    #     MIN(price) AS min_price,
    #     MAX(price) AS max_price,
    #     MIN(scarcity) AS min_scarcity,
    #     MAX(scarcity) AS max_scarcity
    #   FROM reports AS r
    #   INNER JOIN product_details AS d ON r.id=d.report_id
    #   LEFT JOIN products AS p ON p.id=d.product_id
    #   WHERE ST_Distance(coordinates, ST_Point('%s','%s')) < %i
    #   AND r.updated_at > '%s'
    #   GROUP BY p.id, p.name;",
    #   params[:lon],
    #   params[:lat],
    #   [params[:dist].to_i, 1000].max,
    #   params[:since]
    # ])
    # @results = ActiveRecord::Base.connection.execute(@sql)
  end
end
