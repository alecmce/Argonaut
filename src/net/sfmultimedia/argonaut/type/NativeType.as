package net.sfmultimedia.argonaut.type
{
    public class NativeType implements DataType
    {
        private var klass:Class;

        public function NativeType(klass:Class)
        {
            this.klass = klass;
        }

        public function getClass():Class
        {
            return klass;
        }

        public function encode(instance:*):String
        {
            return instance;
        }

        public function decode(value:Object):*
        {
            return value;
        }
    }
}
