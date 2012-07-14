package net.sfmultimedia.argonaut.errors
{
    import net.sfmultimedia.argonaut.ArgonautErrorEvent;

    public class ThrowErrorHandler implements ErrorHandler
    {
        public function handleError(event:ArgonautErrorEvent):void
        {
            throw event.error;
        }
    }
}
