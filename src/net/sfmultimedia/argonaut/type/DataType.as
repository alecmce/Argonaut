package net.sfmultimedia.argonaut.type
{
    public interface DataType
    {
        function getClass():Class;

        function encode(instance:*):String;

        function decode(value:Object):*;
    }
}
