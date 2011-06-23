class DashboardsController < ApplicationController

  def index
    @top_domains = Dashboardstat.top_domains
    @top_hosts = Dashboardstat.top_hosts
    @top_users = Dashboardstat.top_users
    @top_contents = Dashboardstat.top_contents
    
    @network = []
    (1..10).each do |mult|
       # TODO Lo de abajo debería ser hecho con algun tipo de to_json()
       @network.push(Request.live_network('bytes', mult))
    end
    @network.reverse()
    
    
    respond_to do |format|
      format.html
      format.js
    end

  end

  def live_network

    query = params[:query].blank? ? "bytes" : params[:query]
    timeout = params[:timeout].blank? ? 5 : params[:timeout]

    @network = live_network_chart(query, timeout)

    respond_to do |format|
      format.html
      format.json {render :json => @network.to_json}
      format.any {render :json => @network.to_json}
    end

  end

  private
  
    # TODO: Como ya no usamos el helper debemos solo devolver el arreglo
    def live_network_chart(query = "bytes", timeout = 10)
      last_data = Request.live_network(query, timeout)

      network = LazyHighCharts::HighChart.new('spline') do |f|
        f.series(:name => "HOLA", :data => [{:x => last_data[1], :y => last_data[0]}])

        f.options[:chart][:defaultSeriesType] = "spline"
        f.options[:legend][:style] = {}
        f.options[:title] = ""

        f.options[:chart][:events] = {}

      end
      network

    end

end
