package net.sfmultimedia.argonaut
{
    import net.sfmultimedia.argonaut.errors.TraceErrorHandler;

    import org.flexunit.assertThat;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.isFalse;
    import org.hamcrest.object.isTrue;

    public class ArgonautConfigTest
    {
        private var config:ArgonautConfig;

        [Before]
        public function before():void
        {
            config = new ArgonautConfig();
        }

        [Test]
        public function aliasDefaultIsSet():void
        {
            assertThat(config.aliasId, equalTo("__jsonclass__"));
        }

        [Test]
        public function tagClassesWhenEncodingDefaultIsTrue():void
        {
            assertThat(config.tagClassesWhenEncoding, isTrue());
        }

        [Test]
        public function decodeErrorHandleModeDefaultsToTrace():void
        {
            assertThat(config.errorHandler, isA(TraceErrorHandler));
        }

        [Test]
        public function nativeEncodeModeDefaultsToFalse():void
        {
            assertThat(config.nativeEncodeMode, isFalse());
        }
    }
}
