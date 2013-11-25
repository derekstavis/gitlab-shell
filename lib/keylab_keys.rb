require 'tempfile'

require_relative 'keylab_config'
require_relative 'keylab_logger'

class Keylab
  attr_accessor :auth_file, :key

  def initialize
    @command = ARGV.shift
    @key_id = ARGV.shift
    @key = ARGV.shift
    @auth_file = KeylabConfig.new.auth_file
  end

  def exec
    case @command
    when 'add-key'; add_key
    when 'rm-key';  rm_key
    when 'clear';  clear
    else
      $logger.warn "Attempt to execute invalid keylab command #{@command.inspect}."
      puts 'not allowed'
      false
    end
  end

  protected

  def add_key
    $logger.info "Adding key #{@key_id} => #{@key.inspect}"
    open(auth_file, 'a') { |file| file.puts("#{key_header}\n#{@key}") }
  end

  def rm_key
    $logger.info "Removing key #{@key_id}"
    Tempfile.open('authorized_keys') do |temp|
      open(auth_file, 'r+') do |current|
        
        key_index = -1
        current.each_with_index do |line, index|
          if line.include?(key_header)
            key_index = index+1
            next
          elsif key_index == index
            key_index = -1
            next
          else 
            temp.puts(line) 
          end
        end

      end
      temp.close
      FileUtils.cp(temp.path, auth_file)
    end
  end

  def clear
    open(auth_file, 'w') { |file| file.puts '' }
  end

  private

  def key_header
    "# key managed by keylab-shell: #{@key_id}"
  end
end
