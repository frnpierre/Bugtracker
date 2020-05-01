module ProjectsHelper
  
  def project_ownership(project)
    if project.user_id == current_user.id
      "You created this project."
    else 
      "#{project.user.username} created this project.
      You are part of this project team."
    end
  end
end
