require 'spec_helper'

describe 'rake es:drop', type: :cli do

  before { system('rake db:create') }

  def execute!
    system 'rake es:drop'
  end

  it 'is NO-OP' do
    expect { execute! }.not_to change {
      [
        database_exists?(:ar, :development),
        database_exists?(:ar, :test),
        database_exists?(:es, :development),
        database_exists?(:es, :development)
      ]
    }
  end
end