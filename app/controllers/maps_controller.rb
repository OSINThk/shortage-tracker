class MapsController < ApplicationController
  def index
  end

  def results
    # exclusions = get_cursor(cursor)
    # next_cursor = generate_cursor(cursor, x0, y0, x1, y1)

    @results = Report.includes(product_detail: :product)
      .where("ST_Within(coordinates::geometry, ST_MakeEnvelope(?, ?, ?, ?, 4326))", params[:x0], params[:y0], params[:x1], params[:y1])

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

  private
    def get_cursor(cursor)
    end

    def generate_cursor(previous_cursor, x0, y0, x1, y1)
    end
end
