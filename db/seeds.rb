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


Console.create_or_update(id: 1, name: 'PlayStation 3', icon_url: '/icons/ps3.jpg')
Console.create_or_update(id: 2, name: 'PlayStation 4', icon_url: '/icons/ps4.jpg')
Console.create_or_update(id: 3, name: 'Wii U', icon_url: '/icons/wiiu.jpg')
Console.create_or_update(id: 4, name: 'Xbox 360', icon_url: '/icons/xbox360.jpg')
Console.create_or_update(id: 5, name: 'Xbox One', icon_url: '/icons/xboxone.jpg')
Console.create_or_update(id: 6, name: 'Nintendo 3DS', icon_url: '/icons/3ds.jpg')

ShippingType.create_or_update(id: 1, name: 'Same day shipping', price: 18.00, active: true)
ShippingType.create_or_update(id: 2, name: '2 day shipping', price: 8.00, active: true)
ShippingType.create_or_update(id: 3, name: '3 day shipping', price: 5.00, active: true)
ShippingType.create_or_update(id: 4, name: '5-8 day shipping', price: 0.00, active: true)
