class User < ApplicationRecord
    # === Lifecycle callbacks ===
    before_save :downcase_email

    # === Associations ===
    has_many :workouts, dependent: :destroy

    # === Validations ===
    validates :email,    presence: true,
                         length: { maximum: 255 },
                         uniqueness: { case_sensitive: false },
                         format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

    validates :name,     presence: true,
                         length: { maximum: 255 }

    has_secure_password

    validates :password, length: { minimum: 6 },
                         allow_nil: true

    # === Instance methods ===
    def basic_details(with_jwt: false)
        details = UserBlueprint.render_as_hash(
            self,
            view: :basic_details,
            root: :user
        )
        details[:jwt] = generate_jwt if with_jwt
        details
    end

    def generate_jwt
        JsonWebToken.encode(payload: { user_id: self.id })
    end

    # === Class methods ===
    def User.digest(string)
        BCrypt::Password.create(string)
    end

    private

        def downcase_email
            self.email.downcase!
        end
end