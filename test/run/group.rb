class Group < Struct.new(:version, :type)
  def name
    @name ||= [type, version].join('_')
  end

  def directory
    @directory ||= File.join(VERSIONS_FOLDER, name)
  end

  def desc
    "rails #{version}, #{type} DBs"
  end

  def setup!
    Setup.(self)
  end

  def test!
    Test.(self)
  end
end

require_relative './group/setup'
require_relative './group/test'
