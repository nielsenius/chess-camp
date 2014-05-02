class Instructor < ActiveRecord::Base
  include ChessCampHelpers
  
  # relationships
  has_many :camp_instructors
  has_many :camps, through: :camp_instructors
  has_one :user
  
  mount_uploader :picture, PictureUploader
  accepts_nested_attributes_for :user, reject_if: lambda { |user| user[:username].blank? }, allow_destroy: true

  # validations
  validates_presence_of :first_name, :last_name, :phone
  validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "should be 10 digits (area code needed) and delimited with dashes only"
  validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format"

  # scopes
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :needs_bio, -> { where('bio IS NULL') }

  # class methods
  def self.for_camp(camp)
    camp.instructors
  end

  # callbacks
  before_save :reformat_phone
  before_update :deactive_user_if_instructor_inactive
  before_destroy :is_never_destroyable

  # instance methods
  def name
    last_name + ", " + first_name
  end
  
  def proper_name
    first_name + " " + last_name
  end

  private
  def deactive_user_if_instructor_inactive
    if !self.active && !self.user.nil?
      self.user.active = false
      self.user.save
    end
  end
  
end
