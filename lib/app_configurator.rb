require 'logger'

require './lib/database_connector'

class AppConfigurator
  def configure
    setup_i18n
    setup_database
  end

  def get_telegram_token
    YAML::load(IO.read('config/secrets.yml'))['telegram_bot_token']
  end

  def get_botan_token
    YAML::load(IO.read('config/secrets.yml'))['botan_token']
  end

  def get_logger
    # Logger.new(STDOUT, Logger::DEBUG)
    log_file = File.open(YAML::load(IO.read('config/config.yml'))['log_file'], "a")
    Logger.new(MultiIO.new(STDOUT,log_file), Logger::DEBUG)
  end

  private

  def setup_i18n
    I18n.load_path = Dir['config/locales.yml']
    I18n.locale = :en
    I18n.backend.load_translations
  end

  def setup_database
    DatabaseConnector.establish_connection
  end
end

class MultiIO
  def initialize(*targets)
    @targets = targets
  end

  def write(*args)
    @targets.each {|t| t.write(*args)}
  end

  def close
    @targets.each(&:close)
  end
end