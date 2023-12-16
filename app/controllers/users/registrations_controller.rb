# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
    def create
      build_resource(sign_up_params)
  
      if resource.save
        yield resource if block_given?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          respond_with resource, location: new_user_session_path
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: new_user_session_path
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
  end
  

  