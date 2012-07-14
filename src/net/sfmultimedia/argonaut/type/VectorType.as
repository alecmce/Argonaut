package net.sfmultimedia.argonaut.type
{
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    public class VectorType implements DataType
    {
        private static const TYPE:String = "${TYPE}";
        private static const VECTOR:String = "__AS3__.vec::Vector.<${TYPE}>";

        private var elementType:DataType;

        public function setElementType(elementType:DataType):void
        {
            this.elementType = elementType;
        }

        public function getElementType():DataType
        {
            return elementType;
        }

        public function getClass():Class
        {
            var element:String = getQualifiedClassName(elementType.getClass());
            var type:String = VECTOR.replace(TYPE, element);
            return getDefinitionByName(type) as Class;
        }

        public function encode(instance:*):String
        {
            var values:Array = [];

            var length:int = instance.length;
            for (var i:int = 0; i < length; i++)
            {
                values[i] = elementType.encode(instance[i]);
            }

            return "[" + values.join(",") + "]";
        }

        public function decode(value:Object):*
        {
            var klass:Class = getClass();
            var list:* = new klass();

            var count:int = value.length;
            for (var i:int = 0; i < count; i++)
            {
                list[i] = elementType.decode(value[i]);
            }

            return list;
        }
    }
}
