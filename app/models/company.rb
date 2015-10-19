require 'mongoid'

class Company
  include Mongoid::Document

  field :name,       type: String
  field :tickerCode, type: String

  store_in collection: 'company'

  NOT_AVAILABLE_YET = 'N/A'

  def latest_price
    @latest_price || NOT_AVAILABLE_YET
  end

  def latest_stories
    NOT_AVAILABLE_YET
  end

  def as_of
    @as_of || NOT_AVAILABLE_YET
  end

  def price_units
    @price_units || NOT_AVAILABLE_YET
  end

  def story_feed_uri
    @story_feed_uri || NOT_AVAILABLE_YET
  end

  def retrieve_data
    parsed = JSON.parse(CompanyDetailsReader.new(tickerCode).retrieve_data)
    @latest_price   = parsed["latestPrice"]
    @price_units    = parsed["priceUnits"]
    @as_of          = parsed["asOf"]
    @story_feed_uri = parsed["storyFeedUrl"]
    self
  end
end