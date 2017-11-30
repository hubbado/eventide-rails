require 'rails_helper'

describe 'rake es:create' do
  include Support::Database

  def invoke!
    `rake es:create`
  end

  before do
    ensure_no_es_database
  end

  it 'creates all local databases' do
    expect { invoke! }
      .to change { es_database_exists? }.from(false).to(true)
  end

  it 'creates events table' do
    expect {
      Eventide::Rails::Message.count
    }.to raise_error ActiveRecord::NoDatabaseError

    invoke!

    expect(Eventide::Rails::Message.count).to eq 0
  end
end