module ApplicationHelper
  
  def high_chart_colors
    colors = ['#4572A7','#AA4643', '#89A54E', '#80699B', '#3D96AE', '#DB843D', '#92A8CD', '#A47D7C', '#B5CA92']
  end
  
  def bar_size(max_value, value)
    final_value = ((100 * value) / max_value).to_i
    image_tag "graph_bar_standard.gif", :height => '16', :width => final_value, :alt => "#{final_value}%"
  end
  
end
