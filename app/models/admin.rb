class Admin < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]
end
