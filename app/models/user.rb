class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :articles, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  acts_as_follower
  acts_as_followable


  validates :username, uniqueness: { case_sensitive: true },
                       format: { with: /\A[a-zA-Z0-9]+\z/ },
                       presence: true,
                       allow_blank: false

  def generate_jwt

    # JWT.encode({ id: id,
    #              exp: 60.days.from_now.to_i },
    #            Rails.application.secrets.secret_key_base)

  JWT.encode({ id: id,
                 exp: 60.days.from_now.to_i },
               "17f0a8486f8914ca71af814f6f5f8b5799866a797684d33200da4cd13737d4dab44adef8f91bc7e5bed8c99b4893b5549fcd9d9c5326436c203cfb9e7e265f5f")


    #17f0a8486f8914ca71af814f6f5f8b5799866a797684d33200da4cd13737d4dab44adef8f91bc7e5bed8c99b4893b5549fcd9d9c5326436c203cfb9e7e265f5f

  end

  def favorite(article)
    favorites.find_or_create_by(article: article)
  end

  def unfavorite(article)
    favorites.where(article: article).destroy_all

    article.reload
  end

  def favorited?(article)
    favorites.find_by(article_id: article.id).present?
  end
end
