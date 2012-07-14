package net.sfmultimedia.argonaut
{
    import flash.utils.getQualifiedClassName;

    import net.sfmultimedia.argonaut.type.DataType;
    import net.sfmultimedia.argonaut.type.DataTypeFactory;

    public class JSONDecoder
    {
        private var config:ArgonautConfig;
        private var typeFactory:DataTypeFactory;

        public function JSONDecoder(config:ArgonautConfig, typeFactory:DataTypeFactory)
        {
            this.config = config;
            this.typeFactory = typeFactory;
        }

        public function setConfig(config:ArgonautConfig):void
        {
            this.config = config;
        }

        public function decode(json:*, klass:Class = null):*
        {
            if (json == null)
            {
                handleNullInput();
                return null;
            }
            else if (json is String)
            {
                json = JSON.parse(json);
            }

            var definition:String = klass ? getQualifiedClassName(klass) : getTypeString(json);
            var type:DataType = typeFactory.getTypeFromDefinition(definition);
            return type.decode(json)
        }

        private function getTypeString(json:Object):String
        {
            if (json.hasOwnProperty(config.aliasId))
                return json[config.aliasId];
            else
                return getQualifiedClassName(json.constructor as Class);
        }

        private function handleNullInput():void
        {
            var error:Error = new Error("Cannot generate from a null object");
            var event:ArgonautErrorEvent = new ArgonautErrorEvent(ArgonautErrorEvent.DECODING_ERROR, error);
            config.handleError(event);
        }

        private function isNonParticipant(json:Object):Boolean
        {
            if (isNativeType(json))
                return false;

            var aliasId:String = config.aliasId;
            return json.hasOwnProperty(aliasId);
        }

        private function handleNonParticipantInput():void
        {
            var error:Error = new Error("ArgonautJSONDecoder.generate only works on participating classes. The JSON provided must have an " + config.aliasId + " property defined. See generateAs instead.");
            var event:ArgonautErrorEvent = new ArgonautErrorEvent(ArgonautErrorEvent.DECODING_ERROR, error);
            config.handleError(event);
        }

        private function isNativeType(json:Object):Boolean
        {
            return json is Array || json is Boolean || json is Number || json is String;
        }

        private function isParticipant(json:Object):Boolean
        {
            var aliasId:String = config.aliasId;
            return json.hasOwnProperty(aliasId);
        }
    }
}