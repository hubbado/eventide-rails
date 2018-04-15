require 'spec_helper'

describe 'rake es:create', type: :cli do

  before { system 'rake db:drop' }

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