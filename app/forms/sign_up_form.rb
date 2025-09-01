class SignUpForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :email, :string
  attribute :password, :string
  attribute :password_confirmation, :string

  EMAIL_REGEX = /\A[a-z0-9]+([._%+\-][a-z0-9]+)*@[a-z0-9\-]+(\.[a-z0-9\-]+)*\.[a-z]{2,}\z/i

  def email=(v)
    super(v.to_s.strip.downcase)
  end

  validates :name, presence: true
  validates :email, presence: true, format: { with: EMAIL_REGEX }  # ← ここを差し替え
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
end
