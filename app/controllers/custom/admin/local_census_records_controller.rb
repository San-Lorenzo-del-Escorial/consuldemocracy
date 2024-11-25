load Rails.root.join("app", "controllers", "admin", "local_census_records_controller.rb")

class Admin::LocalCensusRecordsController
  private
    def allowed_params
      [:document_type, :document_number, :postal_code]
    end
end
