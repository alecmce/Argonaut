package net.sfmultimedia.argonaut.type
{
    import net.sfmultimedia.argonaut.ArgonautConfig;

    import org.flexunit.assertThat;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;

    public class DataTypeFactory_getTypeFromJSON_Test
    {
        private static const VECTOR_OF_STRING_DEFINITION:String = "__AS3__.vec::Vector.<String>";
        private static const MOCKSTRINGWRAPPER_DEFINITION:String = "net.sfmultimedia.argonaut.type::MockStringWrapper";

        private var config:ArgonautConfig;
        private var factory:DataTypeFactory;

        [Before]
        public function before():void
        {
            config = new ArgonautConfig();
            factory = new DataTypeFactory(config);
        }

        [Test]
        public function canGetStringTypeFromJSON():void
        {
            assertThat(factory.getTypeFromJSON("hello"), isA(StringType));
        }

        [Test]
        public function canGetBooleanTypeFromJSON():void
        {
            assertThat(factory.getTypeFromJSON(true).getClass(), equalTo(Boolean));
        }

        [Test]
        public function canGetNumberTypeFromJSON():void
        {
            assertThat(factory.getTypeFromJSON(3.2).getClass(), equalTo(Number));
        }

        [Test]
        public function canGetArrayTypeFromJSON():void
        {
            assertThat(factory.getTypeFromJSON([1,2,3,4]), isA(ArrayType));
        }

        [Test]
        public function canGetObjectTypeFromJSON():void
        {
            assertThat(factory.getTypeFromJSON({hello:"world"}), isA(ObjectType));
        }

        [Test]
        public function canGetVectorTypeFromJSON():void
        {
            var value:Vector.<String> = new <String>["hello"];
            assertThat(factory.getTypeFromJSON(value), isA(VectorType));
        }

        [Test]
        public function vectorTypeFromJSONCorrectlyNestsElementType():void
        {
            var value:Vector.<String> = new <String>["hello"];
            var type:VectorType = factory.getTypeFromJSON(value) as VectorType;
            assertThat(type.getElementType(), isA(StringType));
        }

        [Test]
        public function canGetClassTypeFromJSON():void
        {
            var object:MockStringWrapper = new MockStringWrapper();

            assertThat(factory.getTypeFromJSON(object), isA(ClassType));
        }

        [Test]
        public function classTypeFromJSONCorrectlyReferencesClass():void
        {
            var object:Object = {__jsonclass__:MOCKSTRINGWRAPPER_DEFINITION,value:"hello"};
            assertThat(factory.getTypeFromJSON(object).getClass(), equalTo(MockStringWrapper));
        }
    }
}
