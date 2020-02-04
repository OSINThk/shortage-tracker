require 'map_cursor'

class MapsController < ApplicationController
  def index
  end

  def results
    root = params["root"]
    parent_cursors = params["cursors"];
    time = DateTime.now
    x0 = params["x0"];
    y0 = params["y0"];
    x1 = params["x1"];
    y1 = params["y1"];

    cursor = MapCursor.new(parent_cursors, time, x0, y0, x1, y1)
    @results = cursor.query(Report.includes(product_detail: :product), root)

    @meta = cursor.meta
    cursor.save

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
