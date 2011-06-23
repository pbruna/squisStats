class Request
  include Mongoid::Document
  field :proxy_server, type: String
  field :date, type: DateTime
  field :epoch, type: Float
  field :bytes, type: Integer
  field :src_host, type: String
  field :hit, type: Boolean
  field :request_method, type: String
  field :url, type: String
  field :domain, type: String
  field :mime, type: String
  index :domain
  index :src_host

  scope :last_5_seconds, where(:date.gt => Time.now.ago(1000)).and(:date.lt => Time.now)

  # Doc en: http://bit.ly/jtfn21, http://bit.ly/j7F6dd y http://bit.ly/kyiSxX
  # El sort se debe hacer "client side" o sea en el array resultante
  def self.lasts(query = 'domain', seconds = 5, limit = 9)
    collection.group({:key => query, :initial => {:sum => 0},
                      :reduce => "function(doc, prev) {prev.sum += doc.bytes}",
                      :cond => {
                        :date => {"$gte" => Time.now.ago(seconds), "$lte" => Time.now} 
                        }
                      }).sort {|a,b| a["sum"] <=> b["sum"]}.slice(0..limit).sort {|a,b| a[query] <=> b[query]}
  end
  
  def self.live_network(query = 'bytes', seconds = 10)
    time_of_query = Time.now()
    sum = where(:date.gte => time_of_query.ago(seconds)).and(:date.lte => time_of_query).sum(query.to_sym)
    sum.nil? ? [0, time_of_query.strftime("%s").to_i] : [sum, time_of_query.strftime("%s").to_i]
  end

end
