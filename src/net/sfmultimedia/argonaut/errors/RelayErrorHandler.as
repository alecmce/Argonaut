package net.sfmultimedia.argonaut.errors
{
    import flash.events.IEventDispatcher;

    import net.sfmultimedia.argonaut.ArgonautErrorEvent;

    public class RelayErrorHandler implements ErrorHandler
    {
        private var eventDispatcher:IEventDispatcher;

        public function RelayErrorHandler(eventDispatcher:IEventDispatcher)
        {
            this.eventDispatcher = eventDispatcher;
        }

        public function handleError(event:ArgonautErrorEvent):void
        {
            eventDispatcher.dispatchEvent(event);
        }
    }
}
