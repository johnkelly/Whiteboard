class Drawing < ActiveRecord::Base
  belongs_to :subscription

  mount_uploader :canvas, CanvasUploader

  validates_presence_of :subscription_id
  validates_presence_of :canvas

  attr_accessible :canvas, :canvas_cache

  before_save :ensure_channel_name
  before_create :enforce_plan_limit

  default_scope order: 'updated_at desc'

  def self.blank_canvas
    File.open(Rails.root.join("public", "empty_canvas.png"))
  end

  def generate_image_from_canvas!(image_data)
    image_data.gsub!("data:image/png;base64,", "")

    temp_file_name = "whiteboard_#{self.id}_#{Time.now.to_i}.png"
    file = File.new(Rails.root.join("tmp", temp_file_name), 'wb')
    file.write(Base64.decode64(image_data))

    self.canvas = file
    self.save!
  end

  def ensure_channel_name
    self.channel_name = SecureRandom.hex(64) if channel_name.blank?
  end

  def enforce_plan_limit
    if self.subscription.drawings.count >= self.subscription.plan_allowed_whiteboards
      errors.add(:base, "You have used all the whiteboards available at your subscription level.  Please upgrade your account to a higher plan or reuse whiteboards.")
      false
    end
  end
end