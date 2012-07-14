package net.sfmultimedia.argonaut
{
    import flash.events.Event;

    public class ArgonautErrorEvent extends Event
    {
        public static const ENCODING_ERROR:String = "ENCODING_ERROR";
        public static const DECODING_ERROR:String = "DECODING_ERROR";
        public static const PARSE_ERROR:String = "PARSE_ERROR";
        public static const REGISTER_ERROR:String = "REGISTER_ERROR";
        public static const CONFIG_ERROR:String = "CONFIG_ERROR";

        public var error:Error;

        public function ArgonautErrorEvent(type:String, error:Error, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.error = error;
        }

        override public function clone():Event
        {
            return new ArgonautErrorEvent(type, error, bubbles, cancelable);
        }
    }
}
