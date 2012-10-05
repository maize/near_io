class Event
  include Mongoid::Document

  embeds_one :facebook_event

  paginates_per 25

  def name
    if facebook_event?
      facebook_event.name
    else
      "N/A"
    end
  end

  def provider
    if facebook_event?
      "facebook"
    end
  end

  def start_time
    if facebook_event?
      facebook_event.start_time
    end
  end

  def end_time
    if facebook_event?
      facebook_event.end_time
    end
  end
end