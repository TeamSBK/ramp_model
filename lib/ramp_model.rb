require "ramp_model/version"
require "rest_client"
require "json"
require "fileutils"

module RampModel
  def self.generate(id)
    @ramp = JSON.parse(RestClient.get("http://ramp-model.herokuapp.com/get_app/#{id}"))
    # check if status is 200
    puts ""
    puts "===== Generating Models ====="
    @ramp["models"].each do |model|
      model_name = model["name"].downcase
      attributes = model["attributes"] ? model["attributes"] : []
      relationships = model["relationships"] ? model["relationships"] : []

      script = "rails generate model #{model_name}"
      script << add_attributes(attributes)
      script << add_relations(relationships)

      # execute generate command
      puts ""
      puts "Executing script:"
      puts script
      system(script)

      # inject other relationships like has_many, has_one direct to model.rb
      inject_other_relationships model_name, relationships if relationships
    end
  end

  def self.add_attributes attributes
    script = ""
    attributes.each do |attr|
      field = attr.keys.first.downcase
      type = attr.values.first.downcase
      script << " #{field}:#{type}"
    end

    return script
  end

  # add belongs_to, polymorphic relationships to script
  def self.add_relations relations
    script = ""
    relations.each do |relation|
      model_name = relation.keys.first.downcase
      assoc = relation.values.first.downcase

      unless assoc == "has_many" || assoc == "has_one"
        script << " #{model_name}:references"
        if assoc == "polymorphic"
          script << "{polymorphic}"
        end
      end
    end
    return script
  end

  # inject has_many, has_one relationships to model.rb
  def self.inject_other_relationships model, relations
    model = model.downcase

    puts "Adding association to #{model}.rb:"
    relations.each do |relation|
      r_model = relation.keys.first.downcase
      assoc = relation.values.first.downcase

      if assoc == "has_many" || assoc == "has_one"
        add_assoc model, r_model, assoc
      end
    end
    return ""
  end

  def self.add_assoc name, r_model, association
    filepath = "#{Rails.root}/app/models/#{name}.rb"
    r_model = r_model.pluralize unless association.downcase == "has_one"
    assoc = "#{association} :#{r_model}"
    puts "#{assoc}"
    replace(filepath, assoc)
  end

  def self.replace(filepath, assoc)
    file = File.readlines(filepath)
    model = File.open(filepath, 'w')
    file.insert(1, "  #{assoc}\n")
    file.each do |line|
      model << line
    end
    model.close
  end
end
