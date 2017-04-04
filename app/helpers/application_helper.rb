module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "μBlogger"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end


  def link_to_event(event)
    if event.eventable
      if event.eventable.type=='μBlog'
        link_to event.eventable.type, micropost_url(event.eventable)
      elsif event.eventable.type=='User'
        link_to event.eventable.get_type, user_url(event.eventable)
      elsif event.eventable.type=='Comment'
        link_to event.eventable.type, micropost_url(event.eventable.micropost)
      end
    end
  end
end
