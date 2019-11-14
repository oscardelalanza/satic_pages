class Micropost < ApplicationRecord
  ################################################## Validations #######################################################
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  ################################################## Relations #########################################################
  belongs_to :user
end
