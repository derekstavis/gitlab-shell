require 'yaml'

class KeylabConfig
  attr_reader :config

  def initialize
    @config = YAML.load_file(File.join(ROOT_PATH, 'config.yml'))
  end

  def auth_file
    @config['auth_file'] ||= "/home/git/.ssh/authorized_keys"
  end

  def log_file
    @config['log_file'] ||= File.join(ROOT_PATH, 'keylab-shell.log')
  end

  def log_level
    @config['log_level'] ||= 'INFO'
  end

end
