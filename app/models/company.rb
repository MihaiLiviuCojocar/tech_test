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
    @latest_stories || []
  end

  def as_of
    return DateTime.parse(@as_of).asctime if @as_of
    NOT_AVAILABLE_YET
  end

  def price_units
    @price_units || NOT_AVAILABLE_YET
  end

  def story_feed_uri
    @story_feed_uri || NOT_AVAILABLE_YET
  end

  def retrieve_data
    set_primary_details_from_parsed
    set_stories_from_parsed if has_stories?
    self
  end

  def has_stories?
    story_feed_uri != NOT_AVAILABLE_YET
  end

  private

  def set_primary_details_from_parsed
    company = JSON.parse(CompanyDetailsReader.new(tickerCode).retrieve_data)
    @latest_price   = company["latestPrice"]
    @price_units    = company["priceUnits"]
    @as_of          = company["asOf"]
    @story_feed_uri = company["storyFeedUrl"]
  end

  def set_stories_from_parsed
    stories = JSON.parse(CompanyNewsFeedRader.new(story_feed_uri).retrieve_data)
    stories.each do |story|
      add_story(Story.new(id: story["id"], headline: story["headline"], body: story["body"]))
    end
  end

  def add_story(story)
    @latest_stories = latest_stories.append(story)
  end
end