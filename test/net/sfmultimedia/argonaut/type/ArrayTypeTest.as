package net.sfmultimedia.argonaut.type
{
    import net.sfmultimedia.argonaut.ArgonautConfig;

    import org.flexunit.assertThat;
    import org.hamcrest.collection.hasItem;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;

    public class ArrayTypeTest
    {

        private static const EXAMPLE_ARRAY:Array = [true, 3.14, "third item", {fourthString:"Chiron"}];
        private static const EXAMPLE_JSON:String = '[true,3.14,"third%20item",{"fourthString":"Chiron"}]';

        private var config:ArgonautConfig;
        private var typeFactory:DataTypeFactory;

        private var type:ArrayType;

        [Before]
        public function before():void
        {
            config = new ArgonautConfig();
            typeFactory = new DataTypeFactory(config);
            type = new ArrayType(typeFactory);
        }


        [Test]
        public function canEncodeJSON():void
        {
            var json:String = type.encode(EXAMPLE_ARRAY);
            assertThat(json, equalTo(EXAMPLE_JSON));
        }

        [Test]
        public function canCastParsedJSON():void
        {
            var parsed:Object = JSON.parse(EXAMPLE_JSON);
            assertThat(type.decode(parsed), isA(Array));
        }

        [Test]
        public function classRoundtripsThroughJSON():void
        {
            var wrapper:MockStringWrapper = new MockStringWrapper();
            wrapper.value = "hello";

            var list:Array = [wrapper, wrapper];
            var json:String = type.encode(list);
            var decoded:Array = type.decode(JSON.parse(json));

            assertThat(decoded, hasItem(isA(MockStringWrapper)));
        }
    }
}
