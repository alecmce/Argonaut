package net.sfmultimedia.argonaut
{
    public interface IArgonaut
    {
        function parse(json:*):*;

        function parseAs(json:*, classObject:Class):*;

        function stringify(instance:*):String;

        function setConfiguration(value:ArgonautConfig):void;

        function getConfiguration():ArgonautConfig;
    }
}
