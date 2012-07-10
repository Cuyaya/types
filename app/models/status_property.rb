class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :values, type: Array, default: []
  field :range_start
  field :range_end
  field :property_id

  attr_accessor :uri
  attr_accessible :values, :range_start, :range_end, :uri

  validates :uri, presence: true, url: true

  embedded_in :status

  before_save :parse_values, :set_property_id


  private 

    def parse_values
      values.map!(&:to_s)
    end

    def set_property_id
      self.property_id = Addressable::URI.parse(uri).basename
    end
end
