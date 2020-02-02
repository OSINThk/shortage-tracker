class MapsController < ApplicationController
  def results
    @sql = "SELECT
      p.id, p.name,
      COUNT(*) AS live_reports,
      MIN(price) AS min_price,
      MAX(price) AS max_price,
      MIN(scarcity) AS min_scarcity,
      MAX(scarcity) AS max_scarcity
    FROM reports AS r
    INNER JOIN product_details AS d ON r.id=d.report_id
    LEFT JOIN products AS p ON p.id=d.product_id
    WHERE ST_Distance(coordinates, ST_Point(#{params[:lon]},#{params[:lat]})) < #{[params[:dist].to_i, 1000].max}
    AND r.updated_at > '#{params[:since]}'
    GROUP BY p.id, p.name;"
    render json: ActiveRecord::Base.connection.execute(@sql)
  end
end
