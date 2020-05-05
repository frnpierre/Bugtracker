module ProjectsHelper
  
  def project_ownership(project)
    # if current user owns the project
    if project.user_id == current_user.id
      if current_page?(projects_path)
        @data = "<p class='project-owner'>You created this project.</p>" 
      else
        index_link = link_to("the project index page", projects_path)
        
        @data = "<div class='project-ownership'>
                  <p>You created this project.</p>
                  
                  <span>You can:</span>
                  <ul>
                    <li>Manage the team</li>
                    <li>Report bugs</li>
                    <li>Mark as solved / edit / delete all the bugs</li>
                    <li>Comment on bugs</li>
                    <li>Edit or delete the project via #{index_link}</li>
                  </ul>
                </div>"
      end
      @data.html_safe
    # if current user doesn't own the project
    else 
      if current_page?(projects_path)
        @data = "<p class='project-owner'>
                   #{project.user.username} created this project.
                   You are part of this project team.
                 </p>" 
      else
        @data = "<div class='project-ownership'>
                  <p>
                    #{project.user.username} created this project.
                    You are part of this project team.
                  </p>
                  
                  <span>You can:</span>
                  <ul>
                    <li>Report bugs</li>
                    <li>Mark as solved / edit / delete your own bugs</li>
                    <li>Comment on all bugs</li>
                  </ul>
                  <p>
                    If you wish to manage the team or all the bugs of the project,
                    you need to log in as #{project.user.username}
                  </p>
                </div>"
      end
      @data.html_safe
    end
  end
end
