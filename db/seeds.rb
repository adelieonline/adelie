# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

class ActiveRecord::Base
  def self.create_or_update(options = {})
    return nil if options.empty?

    id = options.delete(:id)

    record = find_by_id(id) || new
    record.id = id
    record.attributes = options
    record.save!

    record
  end
end


Console.create_or_update(id: 1, name: 'PlayStation 3')
Console.create_or_update(id: 2, name: 'PlayStation 4')
Console.create_or_update(id: 3, name: 'Wii')
Console.create_or_update(id: 4, name: 'Wii U')
Console.create_or_update(id: 5, name: 'Xbox 360')
Console.create_or_update(id: 6, name: 'Xbox One')
