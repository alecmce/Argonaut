package net.sfmultimedia.argonaut.type
{
    public class ArrayType implements DataType
    {
        public var typeFactory:DataTypeFactory;

        public function ArrayType(typeFactory:DataTypeFactory)
        {
            this.typeFactory = typeFactory;
        }

        public function getClass():Class
        {
            return Array;
        }

        public function encode(instance:*):String
        {
            var values:Array = [];

            var length:int = instance.length;
            for (var i:int = 0; i < length; i++)
                values[i] = encodeElement(instance[i]);

            return "[" + values.join(",") + "]";
        }

        private function encodeElement(value:*):*
        {
            var type:DataType = typeFactory.getTypeFromInstance(value);
            return type.encode(value);
        }

        public function decode(value:Object):*
        {
            var list:Array = [];

            var count:int = value.length;
            for (var i:int = 0; i < count; i++)
            {
                var type:DataType = typeFactory.getTypeFromJSON(value[i]);
                list[i] = type.decode(value[i]);
            }

            return list;
        }

    }
}
