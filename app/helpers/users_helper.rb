module UsersHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    arrow_dir = column == params[:sort] ? params[:direction] : ""
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction, search: params[:search] }, { class: "sortable #{ arrow_dir }" }
  end
end
