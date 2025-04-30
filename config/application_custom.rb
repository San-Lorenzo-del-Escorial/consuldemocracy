module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :es
    available_locales = [
      "es",
      "en"
    ]
    config.i18n.available_locales = available_locales
    config.i18n.fallbacks = [I18n.default_locale, {
      "ca" => "es",
      "es-PE" => "es",
      "eu" => "es",
      "fr" => "es",
      "gl" => "es",
      "it" => "es",
      "oc" => "fr",
      "pt-BR" => "es",
      "val" => "es",
      "en" => "es"
    }]
  end
end
