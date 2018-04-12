require 'spec_helper'

describe 'rake es:create', type: :cli do

  before { system 'rake es:drop' }

  def execute!
    system 'rake es:create'
  end

  it 'is NO-OP' do
    expect { execute! }.not_to change do
      [
        database_exists?(:ar, :development),
        database_exists?(:ar, :test),
        database_exists?(:es, :development),
        database_exists?(:es, :development)
      ]
    end
  end
end