module ApplicationHelper
  def sortable(column_name, title = nil)
    title ||= column_name.titleize

    # style variable
    css_class = column_name == sort_column ? "current_name #{sort_direction}" : nil

    # change sorting direction
    direction = (column_name == sort_column && sort_direction == 'asc') ? 'desc' : 'asc'

    link_to title, {:sort => column_name, :direction => direction}, {:class => css_class}
  end
end
