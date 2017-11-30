class CreateEventsTable < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def up
    execute_script script_path('extensions.sql')
    execute_directory('functions')
    execute_directory('table')
    execute_directory('indexes')
  end

  private

  def execute_script(path)
    ActiveRecord::Base.connection.execute File.read(path)
  end

  def execute_directory(dir)
    Dir[script_path dir, '*.sql'].each { |path| execute_script path }
  end

  def script_root
    @script_root ||= File.join(
      Gem::Specification.find_by_name('evt-message_store-postgres').gem_dir,
      'database'
    )
  end

  def script_path(*path)
    File.join script_root, *path
  end
end