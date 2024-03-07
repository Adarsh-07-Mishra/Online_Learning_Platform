# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: %i[google_oauth2]


  has_many :documents, dependent: :destroy
  has_many :links, dependent: :destroy

  has_many :sent_friend_requests, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :received_friend_requests, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :messages, foreign_key: 'user_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'friend_id'

  has_many :accepted_friendships, -> { where(status: 'accepted') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :accepted_friends, through: :accepted_friendships, source: 'friend'

  has_many :sent_friendships, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :received_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  has_many :friendships, -> { where(status: 'accepted') }, class_name: 'Friendship' do
    
    def with_user(user)
      where('user_id = :user_id OR friend_id = :user_id', user_id: user.id)
    end
  end

  validates_presence_of :address, :dob, :skills, :programming_languages

  mount_uploader :profile_picture, ProfilePictureUploader

  def friend_request(friend)
    sent_friend_requests.create(friend: friend)
  end

  def accept_friend_request(friend)
    received_request = received_friend_requests.find_by(user: friend)
    return unless received_request

    transaction do
      received_request.accepted!
      Friendship.create(user: self, friend: friend, status: 'accepted')
      Friendship.create(user: friend, friend: self, status: 'accepted')
    end

    reload
    friend.reload
  end

  def friends
    Friendship.where("(user_id = :user_id OR friend_id = :user_id) AND status = 'accepted'", user_id: id)
              .or(Friendship.where("(user_id = :user_id OR friend_id = :user_id) AND status = 'accepted'",
                                   user_id: id))
  end

  def chat_messages_with(user)
    Message.where('(user_id = :user_id AND friend_id = :friend_id) OR (user_id = :friend_id AND friend_id = :user_id)',
                  user_id: id, friend_id: user.id)
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id email address skills programming_languages created_at updated_at] # Add the attributes you want to make searchable
  end

  def self.ransackable_associations(auth_object = nil)
    %w[accepted_friends accepted_friendships documents friendships links messages received_friend_requests received_friendships received_messages sent_friend_requests sent_friendships]
  end
end
