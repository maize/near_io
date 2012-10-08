class FacebookModel
  def get_facebook_events(access_token)
    events = []
    fb_events = FacebookEvent.get_all_by_facebook_id(self.facebook_id, access_token)
    fb_events.each do |fb_event|
      event = Event.where("facebook_event.facebook_id" => fb_event.facebook_id).first
      if event.nil?
        p "Create new event: "+fb_event.name
        event = Event.new
      else
        p "Update event: "+event.name
      end
      event.facebook_event = fb_event
      event.save
      
      events.push(event)
    end
    events
  end
end