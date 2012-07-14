package net.sfmultimedia.argonaut.type
{
    public class ObjectType implements DataType
    {
        private static const KEYVALUE_PATTERN:String = "\"${key}\":${value}";
        private static const KEY:String = "${key}";
        private static const VALUE:String = "${value}";

        private var typeFactory:DataTypeFactory;

        public function ObjectType(typeFactory:DataTypeFactory)
        {
            this.typeFactory = typeFactory;
        }

        public function getClass():Class
        {
            return Object;
        }

        public function encode(json:*):String
        {
            var values:Array = [];
            for (var property:String in json)
            {
                var value:* = json[property];
                var type:DataType = typeFactory.getTypeFromInstance(value);
                var encoded:String = type.encode(value);

                var str:String = KEYVALUE_PATTERN;
                str = str.replace(KEY, property);
                str = str.replace(VALUE, encoded);
                values.push(str);
            }

            return "{" + values.join(",") + "}";
        }

        public function decode(value:Object):*
        {
            var object:Object = {}

            for (var key:String in value)
            {
                if (key != typeFactory.getAliasId())
                {
                    var type:DataType = typeFactory.getTypeFromJSON(value[key]);
                    object[key] = type.decode(value[key]);
                }
            }

            return object;
        }
    }
}
