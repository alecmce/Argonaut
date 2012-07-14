package net.sfmultimedia.argonaut
{
    import flash.events.EventDispatcher;

    import net.sfmultimedia.argonaut.type.DataTypeFactory;

    public class Argonaut extends EventDispatcher implements IArgonaut
    {
        private var config:ArgonautConfig;
        private var typeFactory:DataTypeFactory;
        private var encoder:JSONEncoder;
        private var decoder:JSONDecoder;

        public function Argonaut()
        {
            config = new ArgonautConfig();
            typeFactory = new DataTypeFactory(config);
            encoder = new JSONEncoder(config, typeFactory);
            decoder = new JSONDecoder(config, typeFactory);
        }

        public function setConfiguration(config:ArgonautConfig):void
        {
            this.config = config;
            typeFactory.setConfig(config);
            encoder.setConfig(config);
            decoder.setConfig(config);
        }

        public function getConfiguration():ArgonautConfig
        {
            return config;
        }

        public function parse(json:*):*
        {
            if (json is String)
                json = processJsonString(json);

            return decoder.decode(json);
        }

        public function parseAs(json:*, classObject:Class):*
        {
            if (json is String)
                json = processJsonString(json);

            return decoder.decode(json, classObject);
        }

        public function stringify(instance:*):String
        {
            return encoder.stringify(instance);
        }

        private function processJsonString(json:String):Object
        {
            var value:Object;

            try
            {
                value = JSON.parse(json);
            }
            catch (error:Error)
            {
                value = null;
                var event:ArgonautErrorEvent = new ArgonautErrorEvent(ArgonautErrorEvent.PARSE_ERROR, error);
                config.handleError(event);
            }

            return value;
        }
    }
}
