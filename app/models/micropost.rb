class Micropost < ApplicationRecord
  include ActiveModel::Validations
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true
  validates_with ContentValidator
  # validates :content, presence: true
  default_scope -> { order(created_at: :desc) }
  validate  :picture_size
  # Validates the size of an uploaded picture.

  before_save :remove_hateful_language

  has_and_belongs_to_many :tags

  has_many :likes, as: :likeable, dependent: :destroy

  has_many :users_microposts, dependent: :destroy

  has_many :events, as: :eventable, dependent: :destroy

  has_many :mentioneds, through: :users_microposts, class_name: 'User', dependent: :destroy

  has_many :comments, dependent: :destroy

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  after_create do
    post = Micropost.find(id)
    tags = content.scan(/#\w+/)
    tags.uniq.map do |tag|
      tag = Tag.find_or_create_by(name: tag.downcase.delete('#'))
      post.tags << tag
    end

    doc = Nokogiri::HTML(content)
    mentions=[]
    m = doc.css('.atwho-inserted')
    m.each do |tmp|
      mentions<<tmp.text
    end
    # mentions = content.scan(/:(.*?):/)
    # mentions = content.scan(/@\w+/)
    mentions.uniq.map do |mention|
      user = User.find_by(uname: mention)
      UsersMicropost.create(micropost_id: post.id, user_id: user.id) if user!=nil
    end
    Event.create(user: user, eventable: self, msg: 'posted')
  end

  before_update do
    post = Micropost.find(id)
    post.tags.clear
    tags = content.scan(/#\w+/)
    tags.uniq.map do |tag|
      tag = Tag.find_or_create_by(name: tag.downcase.delete('#'))
      post.tags << tag
    end

    # post = Micropost.find(id)
    # post.tags.clear
    # tags = content.scan(/#\w+/)
    # tags.uniq.map do |tag|
    #   tag = Tag.find_or_create_by(name: tag.downcase.delete('#'))
    #   post.tags << tag
    # end    
  end

  def type
    'μBlog'
  end

  def get_type
    content
  end

  def get_likes
    likes.count
  end

  def self.popular
    # post_id = Like.where(likeable_type: 'Micropost').group(:likeable_id).count(:likeable_id)
    # id=[]
    # post_id.each do |post|
    #   id<<post[1]
    # end
    # find(id).sort_by(&:get_likes)
    # order(:get_likes)
    all.to_a.sort_by(&:get_likes).reverse
  end

  def remove_hateful_language
    hate_filter = LanguageFilter::Filter.new matchlist: :profanity, replacement: :garbled
    puts("Sanitized #{hate_filter.sanitize(self.content)}")
    self.content = hate_filter.sanitize(self.content)
  end

end