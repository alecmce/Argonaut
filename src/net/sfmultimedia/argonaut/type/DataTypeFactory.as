package net.sfmultimedia.argonaut.type
{
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    import net.sfmultimedia.argonaut.ArgonautConfig;
    import net.sfmultimedia.argonaut.ArgonautErrorEvent;

    public class DataTypeFactory
    {
        internal static const BOOLEAN:String = "Boolean";
        internal static const STRING:String = "String";
        internal static const NUMBER:String = "Number";
        internal static const UINT:String = "uint";
        internal static const INT:String = "int";
        internal static const OBJECT:String = "Object";
        internal static const STAR:String = "*";
        internal static const ARRAY:String = "Array";
        internal static const VECTOR:String = "__AS3__.vec::Vector.";

        private var config:ArgonautConfig;
        private var classMapFactory:ClassMapFactory;

        private var arrayType:ArrayType;
        private var objectType:ObjectType;
        private var stringType:StringType;
        private var typeMap:Object;

        public function DataTypeFactory(config:ArgonautConfig)
        {
            this.config = config;
            classMapFactory = new ClassMapFactory(this);

            makeInstances();
            makeTypeMap();
        }

        public function setConfig(config:ArgonautConfig):void
        {
            this.config = config;
        }

        public function getTypeFromInstance(instance:*):DataType
        {
            var definition:String = getQualifiedClassName(instance);
            return getTypeFromDefinition(definition);
        }

        public function getTypeFromJSON(json:Object):DataType
        {
            if (json.hasOwnProperty(config.aliasId))
                return getTypeFromDefinition(json[config.aliasId]);
            else
                return getTypeFromInstance(json);
        }

        public function getTypeFromDefinition(definition:*):DataType
        {
            return typeMap[definition] || makeDataType(definition);
        }

        public function makeEncodeClassBase(klass:Class):Array
        {
            var base:Array = [];

            if (config.tagClassesWhenEncoding)
            {
                var value:String = EncodingPatterns.STRING_PATTERN;
                value = value.replace(EncodingPatterns.VALUE, getQualifiedClassName(klass));

                var str:String = EncodingPatterns.KEYVALUE_PATTERN;
                str = str.replace(EncodingPatterns.KEY, config.aliasId);
                str = str.replace(EncodingPatterns.VALUE, value);
                base.push(str);
            }

            return base;
        }

        public function getAliasId():String
        {
            return config.aliasId;
        }

        private function makeInstances():void
        {
            stringType = new StringType();
            objectType = new ObjectType(this);
            arrayType = new ArrayType(this);
        }

        private function makeTypeMap():void
        {
            typeMap = {};
            typeMap[BOOLEAN] = new NativeType(Boolean);
            typeMap[STRING] = stringType;
            typeMap[NUMBER] = new NativeType(Number);
            typeMap[UINT] = new NativeType(Number);
            typeMap[INT] = new NativeType(Number);
            typeMap[OBJECT] = objectType;
            typeMap[STAR] = objectType;
            typeMap[ARRAY] = arrayType;
        }

        private function makeDataType(definition:String):DataType
        {
            return isVector(definition) ? makeVectorType(definition) : makeClassType(definition);
        }

        private function makeVectorType(definition:String):VectorType
        {
            var type:VectorType = new VectorType();
            typeMap[definition] = type;
            var elementType:DataType = parseVectorElementType(definition);
            type.setElementType(elementType);
            return type;
        }

        private function parseVectorElementType(definition:String):DataType
        {
            var open:int = definition.indexOf("<");
            var close:int = definition.indexOf(">");
            definition = definition.substring(open + 1, close);
            return getTypeFromDefinition(definition);
        }

        private function makeClassType(definition:String):ClassType
        {
            var klass:Class = getDefinitionByName(definition) as Class;
            var typeMap:ClassTypeMap = classMapFactory.makeClassMap(definition);
            if (typeMap == null)
            {
                handleTypeMapError(definition);
                return null;
            }

            return new ClassType(klass, typeMap, this);
        }

        private function handleTypeMapError(definition:String):void
        {
            var error:Error = new Error("Unable to create ClassTypeMap for " + definition);
            var event:ArgonautErrorEvent = new ArgonautErrorEvent(ArgonautErrorEvent.CONFIG_ERROR, error);
            config.handleError(event);
        }

        private function isVector(type:String):Boolean
        {
            return type.indexOf(VECTOR) != -1;
        }
    }
}
