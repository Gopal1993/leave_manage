class Leave < ApplicationRecord
    has_one_attached :image
    belongs_to :user ,required: false
    validate :image_validation
    #validate :check_image_size
    enum status: [:onhold,:approved, :declined]
    enum leave_type: [:Casual, :Medical]
    after_initialize :set_default_status, :if => :new_record?
    validates :leave_to, :leave_from, :leave_type,:comment, :presence => true
    def set_default_status
        self.status ||= :onhold
      end

    private

    def image_validation
        if image.attached?
          if image.blob.byte_size > 200000
            image.purge
            errors[:base] << 'Too big'
          elsif image.blob.content_type.in?(%w(image/pdf image/jpeg image/jpg)) 
            logo.purge
            errors[:base] << 'Wrong format'
          end
        end
      end

    def check_image_type
        if image.attached? && !image.content_type.in?(%w(image/pdf image/jpeg image/jpg)) 
            errors.add(:image, 'Only pdf or jpeg or jpg format')
        elsif image.attached == false
            errors.add(:image, 'Must have a image attached ')
        end   
    end
    
    def check_image_size
        if image.attached? && image.byte_size >= 200000
            errors.add(:image, 'Image size too big ')
        elsif image.attached == false
            errors.add(:image, 'Must have a image attached ')
       end
    end   
end
