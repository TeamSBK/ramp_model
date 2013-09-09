require "ramp_model/version"
require "rest_client"
require "json"
require "fileutils"

module RampModel
  def self.generate(id)
    # @ramp = JSON.parse(RestClient.get("http://#{url}"))
    @ramp = {
      "status" => "200",
      "database" => "postgres",
      "models" => [
        {
          "name" => "user",
          "fields" => [
            {
              "field" => "username",
              "type" => "string"
            },
            {
              "field" => "email",
              "type" => "string"
            }
          ],
          "associations" => [
            {
              "belongs_to" => [
                {
                  "name" => "department"
                },
                {
                  "name" => "teacher"
                }
              ],
              "has_many" => [
                {
                  "name" => "subjects",
                },
                {
                  "name" => "projects"
                }
              ]
            }
          ]
        }
      ]
    }
    # check if status is 200
    puts "===== Generating Models ====="
    if(@ramp["status"] == "200")
      @ramp["models"].each do |model|
        script = compose_script model
        puts "Executing script: "
        puts "#{script}"
        system("#{script}")
        if model["associations"].first["has_many"]
          puts "Adding has_many associations:"
          add_has_many_association model["name"], model["associations"].first["has_many"]
        end
        puts "Done"
      end
    else
      Rails.logger.info("Error Occured!")
    end
  end

  def self.compose_script model
    script = "rails g model #{model["name"]}"
    model["fields"].each do |field|
      script << " #{field["field"]}:#{field["type"]}"
    end
    model["associations"].first.each do |key, value|
      unless key == "has_many"
        value.each do |v|
          script << " #{v["name"]}:references"
        end
        if key == "polymorphic"
          script << "{polymorphic}"
        end
      end
    end
    return script
  end

  def self.add_has_many_association name, association
    filepath = "#{Rails.root}/app/models/#{name}.rb"
    puts filepath
    association.each do |assoc|
      puts "has_many :#{assoc["name"]}"
      replace(filepath, assoc["name"])
    end
  end

  def self.replace(filepath, assoc)
    file = File.readlines(filepath)
    model = File.open(filepath, 'w')
    file.insert(1, "  has_many :#{assoc}\n")
    file.each do |line|
      model << line
    end
    model.close
  end
end
