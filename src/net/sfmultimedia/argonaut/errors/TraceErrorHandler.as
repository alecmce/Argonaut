package net.sfmultimedia.argonaut.errors
{
    import net.sfmultimedia.argonaut.ArgonautErrorEvent;

    public class TraceErrorHandler implements ErrorHandler
    {
        public function handleError(event:ArgonautErrorEvent):void
        {
            trace("ARGONAUT::", event.type, event.error.message);
        }
    }
}
