class Dashboardstat
  include Mongoid::Document
  field :type, :type => String
  field :name, :type => String
  field :hit, :type => Integer
  field :bytes, :type => Integer
  field :requests, :type => Integer


  def self.top_domains
    domains.top_10.to_a
  end
  
  def self.top_hosts
    hosts.top_10.to_a
  end
  
  def self.top_users
    users.top_10.to_a
  end
  
  def self.top_contents
    mimes.top_10.to_a
  end

# SCOPES
  %w(domain host user mime).each do |type|
    scope type.pluralize.to_sym, where(type: type)
  end
  
  scope :top_10, order_by([:requests, :desc]).limit(10)

end
