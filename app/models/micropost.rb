class Micropost < ApplicationRecord
  ################################################## Validations #######################################################
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size
  
  ################################################## Relations #########################################################
  belongs_to :user
  
  #################################################### configs #########################################################
  default_scope { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  
  #################################################### private #########################################################
  private
  
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
