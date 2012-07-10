module StatusesViewMethods

  def should_have_owned_status(status)
    status = StatusDecorator.decorate(status)
    json = JSON.parse(page.source)
    should_contain_status(status)
    should_not_have_not_owned_statuses
  end

  def should_contain_status(status)
    status = StatusDecorator.decorate(status)
    json = JSON.parse(page.source).first
    should_have_status(status, json)
  end

  def should_have_status(status, json = nil)
    status = StatusDecorator.decorate(status)
    should_have_valid_json
    json = JSON.parse(page.source) unless json 
    json = Hashie::Mash.new json
    json.uri.should == status.uri
    json.id.should == status.id.as_json
    json.name.should == status.name
    json[:pending].should == status.pending
    json.properties.each_with_index do |json_property, index|
      property = StatusPropertyDecorator.decorate(status.properties[index])
      json_property.uri.should == property.uri
      json_property[:values].should == property.values
    end
    json.created_at.should == status.created_at.iso8601
    json.updated_at.should == status.created_at.iso8601
  end

  def should_not_have_not_owned_statuses
    should_have_valid_json
    json = JSON.parse(page.source)
    json.should have(1).item
    Status.all.should have(2).items
  end

end

RSpec.configuration.include StatusesViewMethods
