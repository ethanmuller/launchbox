class Link < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :url
  belongs_to :box
end
