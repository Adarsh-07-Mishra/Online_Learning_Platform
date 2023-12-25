class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         has_many :documents, dependent: :destroy
         has_many :links, dependent: :destroy
         validates_presence_of :address, :dob, :skills, :programming_languages
         mount_uploader :profile_picture, ProfilePictureUploader
        end
