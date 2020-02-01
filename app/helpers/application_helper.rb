module ApplicationHelper
  def get_unique_id
    @unique_id = @unique_id + 1
    "unique-#{@unique_id}"
  end
end
