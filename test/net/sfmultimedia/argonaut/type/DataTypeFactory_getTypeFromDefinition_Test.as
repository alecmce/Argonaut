package net.sfmultimedia.argonaut.type
{
    import net.sfmultimedia.argonaut.ArgonautConfig;

    import org.flexunit.assertThat;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;

    public class DataTypeFactory_getTypeFromDefinition_Test
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
        public function canGetStringTypeFromInstance():void
        {
            var str:String = "hello";
            assertThat(factory.getTypeFromInstance(str), isA(StringType));
        }

        [Test]
        public function canGetStringTypeFromDefinition():void
        {
            assertThat(factory.getTypeFromDefinition("String"), isA(StringType));
        }

        [Test]
        public function canGetBooleanTypeFromDefinition():void
        {
            assertThat(factory.getTypeFromDefinition("Boolean").getClass(), equalTo(Boolean));
        }

        [Test]
        public function canGetNumberTypeFromDefinition():void
        {
            assertThat(factory.getTypeFromDefinition("Number").getClass(), equalTo(Number));
        }

        [Test]
        public function canGetIntTypeFromDefinition():void
        {
            assertThat(factory.getTypeFromDefinition("int").getClass(), equalTo(Number));
        }

        [Test]
        public function canGetUintTypeFromDefinition():void
        {
            assertThat(factory.getTypeFromDefinition("uint").getClass(), equalTo(Number));
        }

        [Test]
        public function canGetArrayTypeFromDefinition():void
        {
            assertThat(factory.getTypeFromDefinition("Array"), isA(ArrayType));
        }

        [Test]
        public function canGetObjectTypeFromDefinition():void
        {
            assertThat(factory.getTypeFromDefinition("Object"), isA(ObjectType));
        }

        [Test]
        public function canGetVectorTypeFromDefinition():void
        {
            assertThat(factory.getTypeFromDefinition(VECTOR_OF_STRING_DEFINITION), isA(VectorType));
        }

        [Test]
        public function vectorTypeFromDefinitionCorrectlyNestsElementType():void
        {
            var type:VectorType = factory.getTypeFromDefinition(VECTOR_OF_STRING_DEFINITION) as VectorType;
            assertThat(type.getElementType(), isA(StringType));
        }

        [Test]
        public function canGetClassTypeFromDefinition():void
        {
            assertThat(factory.getTypeFromDefinition(MOCKSTRINGWRAPPER_DEFINITION), isA(ClassType));
        }

        [Test]
        public function classTypeFromDefinitionCorrectlyReferencesClass():void
        {
            var type:DataType = factory.getTypeFromDefinition(MOCKSTRINGWRAPPER_DEFINITION);
            assertThat(type.getClass(), equalTo(MockStringWrapper));
        }

    }
}
