class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def high_chart_colors
    colors = ['#4572A7','#AA4643', '#89A54E', '#80699B', '#3D96AE', '#DB843D', '#92A8CD', '#A47D7C', '#B5CA92']
  end
  
end
