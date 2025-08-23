class LoginForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :password, :string
  attribute :remember_me, :boolean, default: false

  validates :email, presence: true
  validates :password, presence: true
end