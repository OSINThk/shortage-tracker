require 'map_cursor'
require 'bigdecimal'

class MapsController < ApplicationController
  def index
    # Guess where the request is coming from.
    result = $geoip_city.get(request.remote_ip)

    if !result.nil?
      @latitude = result["location"]["latitude"]
      @longitude = result["location"]["longitude"]
    else
      # Default to Hong Kong
      @latitude = "22.29"
      @longitude = "114.185"
    end

    @localization = {
      "report": {
        "notes": I18n.translate('maps_controller.report.notes', ),
        "created_at": I18n.translate('maps_controller.report.created_at')
      },
      "product": {
        "price": I18n.translate('maps_controller.product.price'),
        "scarcity": I18n.translate('maps_controller.product.scarcity'),
        "notes": I18n.translate('maps_controller.product.notes')
      }
    }
  end

  def results
    params.permit(:format, :x0, :y0, :x1, :y1, :root, :cursors => [], :products => [])

    # BAD: ?root, ?root=, ?root=garbage, ?root[], ?root[]=, ?root[]=garbage
    # GOOD: ?root=1234567
    if params["root"].is_a?(String) && params["root"][/^\h{7}$/]
      root = params["root"]
    end

    # BAD: ?cursors, ?cursors=, ?cursors=garbage, ?cursors[], ?cursors[]=
    # BAD: ?cursors[]=garbage&cursors[]=garbage, ?cursors[]=aaaaaaa&cursors[]=aaaaaaa
    # GOOD: ?cursors[]=1234567&cursors[]=890abcd
    if params["cursors"].is_a?(Array)
      parent_cursors = params["cursors"]
      parent_cursors.reject! {|cursor| !cursor.is_a?(String) || !cursor[/^\h{7}$/] }
      parent_cursors.uniq!
    end

    # BAD: ?products, ?products=, ?products=garbage, ?products[], ?products[]=
    # BAD: ?products[]=garbage&products[]=garbage, ?products[]=aaaaaaa&products[]=aaaaaaa
    # GOOD: ?products[]=1&products[]=2
    if params["products"].is_a?(Array)
      products = params["products"]
      products.reject! {|product| !product.is_a?(String) || !product[/^\d+$/] }
      products.uniq!
    end

    x0 = float_between(params["x0"], 180)
    y0 = float_between(params["y0"], 90)
    x1 = float_between(params["x1"], 180)
    y1 = float_between(params["y1"], 90)

    if (x0.nil? || y0.nil? || x1.nil? || y1.nil?)
      raise ActionController::ParameterMissing.new("You must provide valid coordinates.")
    end

    time = DateTime.now

    cursor = MapCursor.new(parent_cursors, time, x0, y0, x1, y1, products)
    @results = cursor.query(root)

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

  private
    def float_between(possible_string, bound)
      # Is a string.
      if !possible_string.is_a?(String)
        return nil
      else
        as_string = possible_string
      end

      # Matches a string representation of a float.
      if !as_string[/^[-+]?[0-9]*\.?[0-9]+$/]
        return nil
      else
        as_float = as_string.to_f
      end

      # Within bounds.
      if as_float >= -bound.to_f && as_float <= bound.to_f
        return as_float
      else
        return nil
      end
    end
end
