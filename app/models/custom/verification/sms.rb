load Rails.root.join("app", "models", "verification", "sms.rb")
load Rails.root.join("app", "lib", "custom", "sms_api.rb")

class Verification::Sms
  validate :valid_phone_format
  validate :uniqness_phone

  def uniqness_phone
    return if phone.blank?
    errors.add(:phone, :taken) if User.where(confirmed_phone: normalized_phone).any?
  end

  def update_user_phone_information
    user.update(unconfirmed_phone: normalized_phone, sms_confirmation_code: generate_confirmation_code)
  end

  def send_sms
    CustomSmsApi.new.sms_deliver(normalized_phone, user.sms_confirmation_code)
  end

  private

    def normalized_phone
      return nil unless phone.present?
      
      # Remove any non-digit characters except +
      cleaned = phone.gsub(/[^\d+]/, '')
      
      # Handle different formats
      if cleaned.start_with?('+')
        # Remove + and keep the country code
        cleaned[1..-1]
      elsif cleaned.start_with?('00')
        # Remove 00 and keep the country code
        cleaned[2..-1]
      else
        # Assume it's a Spanish number without country code
        "34#{cleaned}"
      end
    end

    def valid_phone_format
      return if phone.blank?
      
      normalized = normalized_phone
      
      # Validate the normalized number
      # Must start with country code (1-3 digits) followed by 6-12 digits
      unless normalized.match?(/\A\d{1,3}\d{6,12}\z/)
        errors.add(:phone, "Debe ser un número de teléfono válido con código de país")
      end
    end
end
