require "buildr/as3"

repositories.remote << "http://artifacts.devboy.org" << "http://repo2.maven.org/maven2"

flexsdk = FlexSDK.new("4.6.0.23201")
flexsdk.from "http://download.macromedia.com/pub/flex/sdk/flex_sdk_4.6.zip"

layout = Layout::Default.new
layout[:source, :main, :as3] = "src"
layout[:source, :test, :as3] = "test"

define "Argonaut", :layout => layout do
	
	project.version = "fleece.1"

	compile.using :compc,
                  :flexsdk => flexsdk

    package :swc

end