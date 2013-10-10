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

ShippingType.create_or_update(id: 1, name: 'Same day shipping', price: 12.00)
ShippingType.create_or_update(id: 2, name: '2 day shipping', price: 8.00)
ShippingType.create_or_update(id: 3, name: '3 day shipping', price: 6.00)
ShippingType.create_or_update(id: 4, name: '5-8 day shipping', price: 0.00)
