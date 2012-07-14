package net.sfmultimedia.argonaut.type
{
    public class StringType implements DataType
    {
        private static const STRING_PATTERN:String = EncodingPatterns.STRING_PATTERN;
        private static const VALUE:String = EncodingPatterns.VALUE;

        public function getClass():Class
        {
            return String;
        }

        public function encode(instance:*):String
        {
            return STRING_PATTERN.replace(VALUE, escape(instance));
        }

        public function decode(value:Object):*
        {
            return value;
        }
    }
}
