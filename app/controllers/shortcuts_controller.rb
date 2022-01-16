class ShortcutsController < ApplicationController
  before_action :authenticate_user!
  before_action :to_explanation

  def new; end
end
