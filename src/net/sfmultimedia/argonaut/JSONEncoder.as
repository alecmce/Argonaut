package net.sfmultimedia.argonaut
{
    import flash.utils.getQualifiedClassName;

    import net.sfmultimedia.argonaut.type.DataType;
    import net.sfmultimedia.argonaut.type.DataTypeFactory;

    public class JSONEncoder
    {
        public var config:ArgonautConfig;
        public var typeFactory:DataTypeFactory;

        private var instanceRegistrar:Array;

        public function JSONEncoder(config:ArgonautConfig, typeFactory:DataTypeFactory)
        {
            this.config = config;
            this.typeFactory = typeFactory;
        }

        public function setConfig(config:ArgonautConfig):void
        {
            this.config = config;
        }

        public function stringify(instance:*):String
        {
            if (config.nativeEncodeMode)
                return JSON.stringify(instance);
            else
                return encodeManually(instance);
        }

        private function encodeManually(instance:*):String
        {
            instanceRegistrar = [];

            var type:DataType = typeFactory.getTypeFromInstance(instance);
            return type.encode(instance);
        }

        private function isInstanceAlreadyEncoded(instance:*):Boolean
        {
            var index:int = instanceRegistrar.indexOf(instance);
            return index > -1 && instance === instanceRegistrar[index];
        }

        private function handleCyclicReferenceError():void
        {
            var error:Error = new Error("ERROR: Cyclic reference found. ArgonautJSONEncoder does not permit recursive references.");
            var event:ArgonautErrorEvent = new ArgonautErrorEvent(ArgonautErrorEvent.ENCODING_ERROR, error);
            config.handleError(event);
        }

        private function isPrimitive(instance:*):Boolean
        {
            return instance is Number || instance is Boolean || instance is String;
        }

        private function updateNullOrVectorType(type:String, klass:Class):String
        {
            if (type == null)
                type = getQualifiedClassName(klass);

            if (type.indexOf(ArgonautConstants.VECTOR) > -1)
                type = ArgonautConstants.VECTOR;

            return type;
        }
    }
}
