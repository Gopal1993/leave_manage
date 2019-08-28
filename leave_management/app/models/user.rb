class User < ApplicationRecord
  enum status: [:active, :inactive]
  enum designation: [:developer, :associate, :hr]
  has_many :leaves,  dependent: :destroy
  after_initialize :set_default_status, :if => :new_record?
  validates :name, :email, :designation, :presence => true
  validates :email, format: { with: /(\A([a-z]*\s*)*\<*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\>*\Z)/i }
  validates :name,format: { with: /\A[a-zA-Z]+\z/,
  message: "only allows letters" }
  
  def set_default_status
    self.status ||= :inactive
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
