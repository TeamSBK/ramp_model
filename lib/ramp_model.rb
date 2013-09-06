require "ramp_model/version"
require "rest-client"
require "json"

module RampModel
  def self.generate url
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
          ]
        }
      ]
    }
    # check if status is 200
    puts "===== Generating Models ====="
    if(@ramp["status"] == "200")
      @ramp["models"].each do |model|
        script = compose_script model
        puts "#{script}"
        exec("#{script}")
        puts "Done"
      end
    else
      #Rails.logger.info("Error Occured!")
    end
  end

  def self.compose_script model
    script = "rails g model #{model["name"]}"
    model["fields"].each do |field|
      script << " #{field["field"]}:#{field["type"]}"
    end
    return script
  end
end
