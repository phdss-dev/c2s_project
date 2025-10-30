module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      notice: "success",
      alert: "danger",
      warning: "warning",
      info: "info"
    }.fetch(flash_type.to_sym, "primary")
  end

  def display_field(value)
    value.presence || tag.em("-", class: "text-muted")
  end
end
