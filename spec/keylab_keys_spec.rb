require_relative 'spec_helper'
require_relative '../lib/keylab_keys'

describe Keylab do
  before do
    $logger = double('logger').as_null_object
  end

  describe :initialize do
    let(:keylab_keys) { build_keylab_keys('add-key', 'key-741', 'ssh-rsa AAAAB3NzaDAxx2E') }

    it { keylab_keys.key.should == 'ssh-rsa AAAAB3NzaDAxx2E' }
    it { keylab_keys.instance_variable_get(:@command).should == 'add-key' }
    it { keylab_keys.instance_variable_get(:@key_id).should == 'key-741' }
  end

  context "file writing tests" do
    before do
      FileUtils.mkdir_p(File.dirname(tmp_authorized_keylab_path))
      open(tmp_authorized_keylab_path, 'w') { |file| file.puts('existing content') }
      keylab_keys.stub(auth_file: tmp_authorized_keylab_path)
    end

    describe :add_key do
      let(:keylab_keys) { build_keylab_keys('add-key', 'key-741', 'ssh-rsa AAAAB3NzaDAxx2E') }

      it "adds a line at the end of the file" do
        keylab_keys.send :add_key
        auth_line = "# key managed by keylab-shell: key-741\nssh-rsa AAAAB3NzaDAxx2E"
        File.read(tmp_authorized_keylab_path).should == "existing content\n#{auth_line}\n"
      end

      it "should log an add-key event" do
        $logger.should_receive(:info).with('Adding key key-741 => "ssh-rsa AAAAB3NzaDAxx2E"')
        keylab_keys.stub(:open)
        keylab_keys.send :add_key
      end
    end

    describe :rm_key do
      let(:keylab_keys) { build_keylab_keys('rm-key', 'key-741', 'ssh-rsa AAAAB3NzaDAxx2E') }

      it "removes the right line" do
        other_line = "# key managed by keylab-shell: key-742\nssh-rsa AAAAB3NzaDAxx2E"
        open(tmp_authorized_keylab_path, 'a') do |auth_file|
          auth_file.puts "# key managed by keylab-shell: key-741\nssh-rsa AAAAB3NzaDAxx2E"
          auth_file.puts other_line
        end
        keylab_keys.send :rm_key
        File.read(tmp_authorized_keylab_path).should == "existing content\n#{other_line}\n"
      end

      it "should log an rm-key event" do
        $logger.should_receive(:info).with('Removing key key-741')
        keylab_keys.send :rm_key
      end
    end
  end

  describe :exec do
    it 'add-key arg should execute add_key method' do
      keylab_keys = build_keylab_keys('add-key')
      keylab_keys.should_receive(:add_key)
      keylab_keys.exec
    end

    it 'rm-key arg should execute rm_key method' do
      keylab_keys = build_keylab_keys('rm-key')
      keylab_keys.should_receive(:rm_key)
      keylab_keys.exec
    end

    it 'should puts message if unknown command arg' do
      keylab_keys = build_keylab_keys('change-key')
      keylab_keys.should_receive(:puts).with('not allowed')
      keylab_keys.exec
    end

    it 'should log a warning on unknown commands' do
      keylab_keys = build_keylab_keys('nooope')
      keylab_keys.stub(puts: nil)
      $logger.should_receive(:warn).with('Attempt to execute invalid keylab command "nooope".')
      keylab_keys.exec
    end
  end

  def build_keylab_keys(*args)
    argv(*args)
    Keylab.new
  end

  def argv(*args)
    args.each_with_index do |arg, i|
      ARGV[i] = arg
    end
  end

  def tmp_authorized_keylab_path
    File.join(ROOT_PATH, 'tmp', 'authorized_keys')
  end
end
