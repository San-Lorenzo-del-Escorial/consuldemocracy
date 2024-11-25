load Rails.root.join("app", "models", "verification", "residence.rb")

class Verification::Residence
    private

    def residency_valid?
      census_data.valid? &&
        census_data.postal_code == postal_code
    end
end
