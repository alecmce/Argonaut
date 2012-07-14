package net.sfmultimedia.argonaut.errors
{
    import net.sfmultimedia.argonaut.ArgonautErrorEvent;

    public class SilentErrorHandler implements ErrorHandler
    {
        public function handleError(event:ArgonautErrorEvent):void {}
    }
}
