class User < ApplicationRecord
    has_secure_password

    has_one :cart
    has_one_attached :cart_report
end
