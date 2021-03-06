class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_max_length}
  validate :picture_size

  scope :desc, -> {order created_at: :desc}
  scope :feed, -> (following_ids, id){
    Micropost.where("user_id IN (?)
      OR user_id = (?)", following_ids, id)
  }

  mount_uploader :picture, PictureUploader

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, I18n.t("size_error")
    end
  end
end
