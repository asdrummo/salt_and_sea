class Users::RegistrationsController < Devise::RegistrationsController
  protected
  
  def after_sign_in_path_for(resource) unless user_signed_in?
    if (URI(request.referer).path == '/users/sign_in') 
      root_path 
    elsif (URI(request.referer).path == '/users/sign_up')
      root_path
    elsif (URI(request.referer).path == '/users/password/edit')
      root_path
    else
      request.referer
    end
  end
  root_path
    
  end
  
  
end