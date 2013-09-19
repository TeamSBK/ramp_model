require 'spec_helper'

describe RampModel do
  context '#add_attributes' do
    it "add field and field type to script" do
      attributes = [
        {
          "first_name" => "string"
        },
        {
          "last_name" => "string"
        }
      ]
      RampModel.add_attributes(attributes).should eq(" first_name:string last_name:string")
    end
  end

  context '#add_relations' do
    it "add belongs_to or polymorphic relationship to script" do
      relations = [
        {
          "department" => "belongs_to"
        },
        {
          "comment" => "polymorphic"
        }
      ]
      RampModel.add_relations(relations).should eq(" department:references comment:references{polymorphic}")
    end
  end
end
