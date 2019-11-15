class Micropost < ApplicationRecord
  ################################################## Validations #######################################################
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  ################################################## Relations #########################################################
  belongs_to :user
  
  #################################################### configs #########################################################
  default_scope { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
end
