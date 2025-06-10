class User::Exporter
  require "csv"
  include JsonExporter

  def initialize(users)
    @users = users
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << headers
      @users.each { |user| csv << csv_values(user) }
    end
  end

  def model
    User
  end

  private

    def headers
      [
        I18n.t("admin.users.columns.id"),
        I18n.t("admin.users.columns.name"),
        I18n.t("admin.users.columns.email"),
        I18n.t("admin.users.columns.phone_number"),
        I18n.t("admin.users.columns.verification_level"),
        I18n.t("admin.users.columns.activation_status")
      ]
    end

    def csv_values(user)
      [
        user.id.to_s,
        user.name,
        user.email,
        user.phone_number,
        user.verified_at? ? I18n.t("admin.users.account.verified_status") : I18n.t("admin.users.account.not_verified_status"),
        user.confirmed_at? ? I18n.t("admin.users.account.active_status") : I18n.t("admin.users.account.inactive_status"),
      ]
    end

    def json_values(user)
      {
        id: user.id,
        name: user.name,
        email: user.email,
        phone_number: user.phone_number,
      }
    end
end
