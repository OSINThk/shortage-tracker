class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:admin]

  def about
  end

  def admin
    authorize :pages, :admin?
  end
end
