require 'spec_helper'

describe 'schema.rb behaviour', type: :cli do

  before { system 'rake db:create db:migrate' }

  it 'is NO-OP' do
    expect { system 'rake es:create' }
      .not_to(change {
        [
          database_exists?(:ar, :development),
          database_exists?(:ar, :test),
          database_exists?(:es, :development),
          database_exists?(:es, :development)
        ]
      })
  end
end