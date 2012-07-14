package net.sfmultimedia.argonaut
{
    import flash.display.Sprite;
    import flash.text.TextField;

    import mx.core.ByteArrayAsset;

    import net.sfmultimedia.argonaut.type.DataTypeFactory;

    import org.flexunit.assertThat;
    import org.hamcrest.collection.hasItems;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.hasProperties;
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.object.isTrue;

    public class JSONDecoderTest extends Sprite
	{
        [Embed(source="participating.json",mimeType="application/octet-stream")]
        private static const embedded_participating_json:Class;

        private static var json:Object;

        private var config:ArgonautConfig;
        private var factory:DataTypeFactory;
        private var decoder:JSONDecoder;

        [BeforeClass]
        public static function setup():void
        {
            var forcesImportOfTestSubClass:TestSubClass;
            var forcesImportOfTestSuperClass:TestSuperClass;

            var embeddedJSON:ByteArrayAsset = new embedded_participating_json() as ByteArrayAsset;
            json = JSON.parse(embeddedJSON.toString());
        }

        [AfterClass]
        public static function teardown():void
        {
            json = null;
        }

		[Before]
		public function before():void
		{
            config = new ArgonautConfig();
            factory = new DataTypeFactory(config);
            decoder = new JSONDecoder(config, factory);
        }

		[Test]
		public function generateAsReturnsCorrectType():void
		{
			assertThat(decoder.decode(json, TestSubClass), isA(TestSubClass));
		}

        [Test]
        public function generateCorrectlyTypesOutput():void
        {
            assertThat(decoder.decode(json), isA(TestSubClass));
        }

        [Test]
        public function decodesNumber():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aNumber, equalTo(102.25));
        }

        [Test]
        public function decodesInt():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.anInt, equalTo(-100));
        }

        [Test]
        public function decodesUint():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aUint, equalTo(100));
        }

        [Test]
        public function decodesBoolean():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aBoolean, isTrue());
            assertThat(decoded.aBoolean, isTrue());
        }

        [Test]
        public function decodesString():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aString, equalTo("Hera"));
        }

        [Test]
        public function decodesArray():void
        {
            var expected:Array = [true, 3.14, "third item", hasProperty("fourthString", "Chiron")];

            var json:String = JSON.stringify([true, 3.14, "third item", {fourthString:"Chiron"}]);
            var decoded:Array = decoder.decode(json);
            assertThat(decoded, hasProperties(expected));
        }

        [Test]
        public function decodesStarredObjects():void
        {
            var expected:Object =
            {
                aStarString: "Phineas",
                aStarNumber: 7
            };

            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aStar, hasProperties(expected));
        }

        [Test]
        public function decodesObjects():void
        {
            var expected:Object =
            {
                anObjectFalse:false,
                anObjectTrue:true,
                anObjectObject:hasProperty("anObjectObjectString", "Talos")
            };

            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.anObject, hasProperties(expected));
        }

        [Test]
        private function decodesTextFields():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aComplexObject, isA(TextField));
        }

        [Test]
        private function decodesTextFieldProperties():void
        {
            var expected:Object =
            {
                text:"Thessalus",
                x: 20.5,
                y: 100
            };

            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aComplexObject, hasProperties(expected));
        }

        [Test]
        public function decodesSubClassNumber():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aNumberInSubClass, equalTo(999));
        }

        [Test]
        public function decodesVectorOfStrings():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aVectorOfStrings, isA(Vector.<String>));
        }

        [Test]
        public function decodesStringVectorValues():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aVectorOfStrings, hasItems("Heracles","Bellerophon","Castor"));
        }

        [Test]
        public function decodesComplexVector():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aVectorOfComplexity, isA(Vector.<TestVectorElement>));
        }

        [Test]
        public function decodesComplexVectorValues():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aVectorOfComplexity, hasItems(hasProperty("age",30),hasProperty("age",21),hasProperty("age",22)));
        }

        [Test]
        public function decodesVectorWithSubtypeValues():void
        {
            var decoded:TestSubClass = decoder.decode(json);
            assertThat(decoded.aVectorWithSubtypes[2], isA(TestVectorSubElement));
        }


	}
}