package net.sfmultimedia.argonaut.errors
{
    import net.sfmultimedia.argonaut.ArgonautErrorEvent;

    public interface ErrorHandler
    {
        function handleError(event:ArgonautErrorEvent):void;
    }
}
