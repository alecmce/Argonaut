package net.sfmultimedia.argonaut
{
    import net.sfmultimedia.argonaut.errors.ErrorHandler;
    import net.sfmultimedia.argonaut.errors.TraceErrorHandler;

    public class ArgonautConfig
	{
        private static const DEFAULT_ALIAS_ID:String = "__jsonclass__";

        public var aliasId:String;
		public var tagClassesWhenEncoding:Boolean;
		public var nativeEncodeMode:Boolean;
		public var errorHandler:ErrorHandler;

        public function ArgonautConfig()
        {
            aliasId = DEFAULT_ALIAS_ID;
            tagClassesWhenEncoding = true;
            nativeEncodeMode = false;
            errorHandler = new TraceErrorHandler();
        }

        public function handleError(event:ArgonautErrorEvent):void
        {
            if (errorHandler)
                errorHandler.handleError(event);
        }
    }
}
