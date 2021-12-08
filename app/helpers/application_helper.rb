module ApplicationHelper

  private
  
  def object_to_s(object)
    object.class.to_s.downcase
  end
end
