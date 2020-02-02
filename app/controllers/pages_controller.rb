class PagesController < ApplicationController
  def about
  end

  def admin
    authorize :pages, :admin?
  end
end
