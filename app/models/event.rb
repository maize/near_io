class Event
  include Mongoid::Document

  embeds_one :facebook_event

  paginates_per 25

  def name
    unless facebook_event.nil?
      self.facebook_event.name
    else
      "N/A"
    end
  end

  def description
    unless facebook_event.nil?
      self.facebook_event.description
    else
      "..."
    end
  end

  def provider
    unless facebook_event.nil?
      "facebook"
    end
  end

  def start_time
    unless facebook_event.nil?
      self.facebook_event.start_time
    end
  end

  def end_time
    unless facebook_event.nil?
      self.facebook_event.end_time
    end
  end
end