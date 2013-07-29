# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Oladium::Application
run Rack::URLMap.new( {
    "/minecraft_gate" => MinecraftGateApplication,
    "/" => Oladium::Application
} )
