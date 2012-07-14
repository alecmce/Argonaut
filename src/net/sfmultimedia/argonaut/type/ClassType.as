package net.sfmultimedia.argonaut.type
{
    public class ClassType implements DataType
    {
        private var klass:Class;
        private var typeMap:ClassTypeMap;
        private var typeFactory:DataTypeFactory;

        public function ClassType(klass:Class, typeMap:ClassTypeMap, typeFactory:DataTypeFactory)
        {
            this.klass = klass;
            this.typeMap = typeMap;
            this.typeFactory = typeFactory;
        }

        public function getClass():Class
        {
            return klass;
        }

        public function encode(instance:*):String
        {
            var values:Array = typeFactory.makeEncodeClassBase(klass);

            for each (var key:String in typeMap.getProperties())
            {
                var value:* = instance[key];
                if (value != null)
                {
                    var type:DataType = typeMap.getType(key);
                    var encoded:String = type.encode(value);

                    var str:String = EncodingPatterns.KEYVALUE_PATTERN;
                    str = str.replace(EncodingPatterns.KEY, key);
                    str = str.replace(EncodingPatterns.VALUE, encoded);
                    values.push(str);
                }
            }

            return "{" + values.join(",") + "}";
        }

        public function decode(target:Object):*
        {
            var resolvedClass:Class = resolveClass(target);
            var object:Object = new resolvedClass();

            for (var key:String in target)
            {
                if (key != typeFactory.getAliasId())
                {
                    var type:DataType = typeMap.getType(key);
                    if (type)
                    {
                        var value:* = type.decode(target[key]);
                        object[key] = value;
                    }
                }
            }

            return object;
        }

        private function resolveClass(target:Object):Class
        {
            if (target.hasOwnProperty(typeFactory.getAliasId()))
                return typeFactory.getTypeFromJSON(target).getClass();
            else
                return klass;
        }

    }
}
