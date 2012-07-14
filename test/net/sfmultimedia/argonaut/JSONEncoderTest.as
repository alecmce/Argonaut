package net.sfmultimedia.argonaut
{
    import flash.display.Sprite;
    import flash.text.TextField;

    import net.sfmultimedia.argonaut.type.DataTypeFactory;

    import org.flexunit.assertThat;
    import org.hamcrest.collection.everyItem;
    import org.hamcrest.collection.hasItems;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.hasProperties;
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.object.isTrue;
    import org.hamcrest.object.nullValue;

    public class JSONEncoderTest extends Sprite
    {
        private var instance:TestSubClass;

        private var config:ArgonautConfig;
        private var factory:DataTypeFactory;
        private var encoder:JSONEncoder;

        private var json:String;
        private var decoded:Object;

        [Before]
        public function before():void
        {
            config = new ArgonautConfig();
            factory = new DataTypeFactory(config);
            encoder = new JSONEncoder(config, factory);

            makeInstance();
        }

        private function makeInstance():void
        {
            var anObjectObject:Object = {anObjectObjectString:"Talos"};
            var anObject:Object = {anObjectFalse:false, anObjectTrue:true, anObjectObject:anObjectObject};

            var heracles:TestVectorElement = new TestVectorElement("Heracles", 30);
            var bellerophon:TestVectorElement = new TestVectorElement("Bellerophon", 21);
            var castor:TestVectorElement = new TestVectorElement("Castor", 22);

            instance = new TestSubClass();
            instance.aBoolean = true;
            instance.aComplexObject = new TextField();
            instance.aComplexObject.text = "Thessalus";
            instance.aComplexObject.x = 20.5;
            instance.aComplexObject.y = 100;
            instance.anArray = [true, 3.14, "third item", {fourthString:"Chiron"}];
            instance.anInt = -100;
            instance.anObject = anObject;
            instance.aNonserialized = "This shouldn't get serialized";
            instance.aNumber = 102.25;
            instance.aNumberInSubClass = 999;
            instance.aStar = {aStarString:"Phineas", aStarNumber:7};
            instance.aString = "Hera";
            instance.aUint = 100;
            instance.aVectorOfComplexity = new <TestVectorElement>[heracles, bellerophon, castor];
            instance.aVectorOfStrings = new <String>["Heracles", "Bellerophon", "Castor"];
        }

        private function encode():void
        {
            json = encoder.stringify(instance);
            decoded = JSON.parse(json);
        }

        [Test]
        public function stringifiedObjectContainsClassData():void
        {
            encode();
            assertThat(decoded.__jsonclass__, equalTo("net.sfmultimedia.argonaut::TestSubClass"));
        }

        [Test]
        public function stringifiedNumberCanBeParsed():void
        {
            encode();
            assertThat(decoded.aNumber, equalTo(102.25));
        }
        
        [Test]
        public function stringifiedIntCanBeParsed():void
        {
            encode();
            assertThat(decoded.anInt, equalTo(-100));
        }

        [Test]
        public function stringifiedUintCanBeParsed():void
        {
            encode();
            assertThat(decoded.aUint, equalTo(100));
        }
        
        [Test]
        public function stringifiedBooleanCanBeParsed():void
        {
            encode();
            assertThat(decoded.aBoolean, isTrue());
        }

        [Test]
        public function stringifiedStringCanBeParsed():void
        {
            encode();
            assertThat(decoded.aString, equalTo("Hera"));
        }

        [Test]
        public function stringifiedArrayCanBeParsed():void
        {
            encode();
            var expected:Array = [true, 3.14, "third%20item", hasProperty("fourthString", "Chiron")];
            assertThat(decoded.anArray, hasProperties(expected));
        }
        
        [Test]
        public function stringifiedStarCanBeParsed():void
        {
            encode();
            var expected:Object =
            {
                aStarString: "Phineas",
                aStarNumber: 7
            }

            assertThat(decoded.aStar, hasProperties(expected));
        }

        [Test]
        public function stringifiedObjectsCanBeParsed():void
        {
            encode();
            var expected:Object =
            {
                anObjectFalse:false,
                anObjectTrue:true,
                anObjectObject:hasProperty("anObjectObjectString", "Talos")
            };

            assertThat(decoded.anObject, hasProperties(expected));
        }

        [Test]
        private function stringifiedTextFieldsCanBeParsed():void
        {
            encode();
            assertThat(decoded.aComplexObject, isA(TextField));
        }

        [Test]
        private function stringifiedTextFieldPropertiesCanBeParsed():void
        {
            encode();
            var expected:Object =
            {
                text:"Thessalus",
                x: 20.5,
                y: 100
            }

            assertThat(decoded.aComplexObject, hasProperties(expected));
        }

        [Test]
        public function stringifiedSubClassNumberCanBeParsed():void
        {
            encode();
            assertThat(decoded.aNumberInSubClass, equalTo(999));
        }

        [Test]
        public function stringifiedStringVectorValuesCanBeParsed():void
        {
            encode();
            assertThat(decoded.aVectorOfStrings, hasItems("Heracles","Bellerophon","Castor"));
        }

        [Test]
        public function stringifiedComplexVectorCanBeParsed():void
        {
            encode();
            var type:String = "net.sfmultimedia.argonaut::TestVectorElement";
            assertThat(decoded.aVectorOfComplexity, everyItem(hasProperty("__jsonclass__", type)));
        }

        [Test]
        public function stringifiedComplexVectorValuesCanBeParsed():void
        {
            encode();
            assertThat(decoded.aVectorOfComplexity, hasItems(hasProperty("age",30),hasProperty("age",21),hasProperty("age",22)));
        }

        [Test]
        public function dontSerializeMarkedVariables():void
        {
            encode();
            assertThat(decoded.aNonserialized, nullValue());
        }

        [Test]
        public function dontSerializeMarkedConstants():void
        {
            encode();
            assertThat(decoded.aConstantSuppressed, nullValue());
        }
    }
}
