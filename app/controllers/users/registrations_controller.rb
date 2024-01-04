# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[email password password_confirmation address dob skills
                                               programming_languages profile_picture])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[email password password_confirmation current_password address dob skills programming_languages
                                               profile_picture])
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :address, :dob, :skills,
                                 :programming_languages, :profile_picture)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :address, :dob, :skills,
                                 :programming_languages, :profile_picture)
  end
end
