class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :decks, dependent: :destroy

  # これで取りこぼし無し（破壊的メソッド連鎖より安全）
  before_validation :normalize_email

  # 先頭は英数、途中は ._%+- と英数の繰り返し、@ の後は英数/ハイフン + ドット + TLD(2文字以上)
  EMAIL_REGEX = /\A[a-z0-9]+([._%+\-][a-z0-9]+)*@[a-z0-9\-]+(\.[a-z0-9\-]+)*\.[a-z]{2,}\z/i

  validates :name, presence: true, length: { maximum: 30 }
  validates :email,
    presence: true,
    length: { maximum: 254 },
    format: { with: EMAIL_REGEX },                 # ← ここを差し替え
    uniqueness: { case_sensitive: false }

  validates :password, presence: true, if: -> { new_record? || will_save_change_to_attribute?(:crypted_password) }
  validates :password, confirmation: true, if: -> { password.present? }

  private
  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
