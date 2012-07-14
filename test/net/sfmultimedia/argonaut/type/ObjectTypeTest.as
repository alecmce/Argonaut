package net.sfmultimedia.argonaut.type
{
    import net.sfmultimedia.argonaut.ArgonautConfig;

    import org.flexunit.assertThat;
    import org.hamcrest.collection.hasItem;
    import org.hamcrest.core.allOf;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.text.containsString;
    import org.hamcrest.text.containsStrings;

    public class ObjectTypeTest
    {
        private static const EXAMPLE_OBJECT:Object = {hello:["world","mars"], name:"Argo"};
        private static const EXAMPLE_JSON_PARTIAL1:String = '"hello":["world","mars"]';
        private static const EXAMPLE_JSON_PARTIAL2:String = '"name":"Argo"';

        private var config:ArgonautConfig;
        private var typeFactory:DataTypeFactory;

        private var type:ObjectType;

        [Before]
        public function before():void
        {
            config = new ArgonautConfig();
            typeFactory = new DataTypeFactory(config);
            type = new ObjectType(typeFactory);
        }


        [Test]
        public function canEncodeJSON():void
        {
            var json:String = type.encode(EXAMPLE_OBJECT);
            assertThat(json, containsStrings(EXAMPLE_JSON_PARTIAL1, EXAMPLE_JSON_PARTIAL2));
        }

        [Test]
        public function classRoundtripsThroughJSON():void
        {
            var wrapper:MockStringWrapper = new MockStringWrapper();
            wrapper.value = "hello";

            var object:Object = {hello:wrapper};
            var json:String = type.encode(object);
            var decoded:Object = type.decode(JSON.parse(json));

            assertThat(decoded.hello, isA(MockStringWrapper));
        }
    }
}
