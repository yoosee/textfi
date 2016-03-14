module ApplicationHelper
  def is_page_in(controller_name, action_name)
    controller.controller_name == controller_name &&
      controller.action_name == action_name
  end
end
