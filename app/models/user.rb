class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :age ,  numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 130}, on: :update
  has_secure_password
  
 has_many :microposts
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
                                    
  has_many :follower_users, through: :follower_relationships, source: :follower

  has_many :likes, dependent: :destroy 
  has_many :like_microposts, through: :likes, source: :micropost

  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  def following?(other_user)
    following_users.include?(other_user)
  end
 
 
  def create_like(micropost)  
   likes.find_or_create_by(micropost_id: micropost.id) 
  end

 def remove_like(micropost)
   like = likes.find_by(micropost_id: micropost.id)
   like.destroy if like
 end   
 
   def like?(micropost)
     like_microposts.include?(micropost)
   end

  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end
  
  def feed_likes
    Micropost.where(micropost_id: micropost.id + [self.id])
  end
end  

def all_users
    User.all
end