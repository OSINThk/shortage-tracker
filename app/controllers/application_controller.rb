class ApplicationController < ActionController::Base
  include Pundit

  private
    def initialize
      # Counter that is reset per request.
      @unique_id = 0
      super()
    end
end
