require 'bundler'

class Group::Test
  def self.call(group)
    new(group).call
  end

  def initialize(group)
    @group = group
  end

  def call
    print "Running tests for #{desc}: "
    Bundler.with_clean_env do
      Dir.chdir(directory)
      quiet_system 'rake db:create'
      begin
        test 'rspec spec/features'
        quiet_system 'rake db:create'
        test 'rspec spec/integration'
      ensure
        quiet_system 'rake db:drop'
        puts
      end
    end
  end

  private

  include Utils
  delegate :desc, :directory, to: :@group

  def quiet_system(cmd)
    system(cmd, out: File::NULL, err: File::NULL)
  end

  def test(cmd)
    if quiet_system(cmd)
      print '.'
    else
      print '!'
    end
  end
end
