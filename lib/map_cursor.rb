require 'digest'
require 'date'

MAX_REPORT_AGE = ENV.fetch("MAX_REPORT_AGE", 1).to_i

class MapCursor
  @@field_separator = "~"
  @@value_separator = ","
  @@expiration_seconds = 60*60*24

  def initialize(parent_cursors, since, x0, y0, x1, y1, products)
    @parent_cursors = parent_cursors || []

    if since.class == String
      @since = DateTime.parse(since)
    elsif since.class == DateTime
      @since = since
    else
      raise ArgumentError.new("`since` must be of type String or DateTime.")
    end

    @since = @since.new_offset(0)
    @x0 = x0
    @y0 = y0
    @x1 = x1
    @y1 = y1
    @products = products
  end

  def self.parse(cursor_value)
    parent_cursors, since, coordinates, products = cursor_value.split(@@field_separator)
    parent_cursors = parent_cursors.length == 0 ? [] : parent_cursors.split(@@value_separator)
    x0, y0, x1, y1 = coordinates.split(@@value_separator)
    products = parent_cursors.length == 0 ? nil : parent_cursors.split(@@value_separator)

    return MapCursor.new(parent_cursors, DateTime.parse(since), x0, y0, x1, y1, products)
  end

  def key
    Digest::SHA1.hexdigest(value()).slice(0, 7)
  end

  def value
    [
      @parent_cursors.join(@@value_separator),
      @since.strftime('%FT%T'),
      [@x0, @y0, @x1, @y1].join(@@value_separator),
      @products&.join(@@value_separator)
    ].join(@@field_separator)
  end

  def meta
    return {
      cursor: key(),
      value: value(),
      parents: @parent_cursors
    }
  end

  def get_parents(root = nil)
    parents = []

    # Don't try to load parents beyond the root.
    if root != key()
      @parent_cursors.each do |parent_cursor_key|
        parent_cursor_value = Redis.current.get(parent_cursor_key)

        # If it doesn't come back who cares.
        if (!parent_cursor_value.nil?)
          parents << MapCursor::parse(parent_cursor_value)
        end
      end
    end

    return parents
  end

  def query(root = nil)
    active_record_query = Report

    if !@products.nil?
      active_record_query = filter_products(active_record_query)
    end

    active_record_query = active_record_query.includes(product_detail: { product: :localization })
    active_record_query = where(active_record_query)
    active_record_query = get_exclusions(active_record_query, root)
    return active_record_query
  end

  def save
    Redis.current.set(key(), value(), ex: @@expiration_seconds)
  end

  protected
    def filter_products(active_record_query)
      return active_record_query
        .joins(:product_detail)
        .where(product_details: { product_id: @products })
    end

    def get_exclusions(active_record_query, root)
      parent_cursors = get_parents(root)
      parent_cursors.each do |parent_cursor|
        active_record_query = parent_cursor.where_not(active_record_query)
        parent_cursor.get_exclusions(active_record_query, root)
      end

      return active_record_query
    end

    def where(active_record_query)
      return active_record_query
        .where("ST_Within(coordinates::geometry, ST_MakeEnvelope(?, ?, ?, ?, 4326))", @x0, @y0, @x1, @y1)
        .where("reports.updated_at > ?", (@since - MAX_REPORT_AGE).to_s)
    end

    def where_not(active_record_query)
      return active_record_query
        .where.not("ST_Within(coordinates::geometry, ST_MakeEnvelope(?, ?, ?, ?, 4326))", @x0, @y0, @x1, @y1)
        .or(active_record_query.where("reports.updated_at > ?", @since.to_s))
    end
end
