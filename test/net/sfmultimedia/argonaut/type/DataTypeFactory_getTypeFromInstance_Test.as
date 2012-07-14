package net.sfmultimedia.argonaut.type
{
    import net.sfmultimedia.argonaut.ArgonautConfig;

    import org.flexunit.assertThat;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;

    public class DataTypeFactory_getTypeFromInstance_Test
    {
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
            assertThat(factory.getTypeFromInstance("hello"), isA(StringType));
        }

        [Test]
        public function canGetBooleanTypeFromInstance():void
        {
            assertThat(factory.getTypeFromInstance(false).getClass(), equalTo(Boolean));
        }

        [Test]
        public function canGetNumberTypeFromInstance():void
        {
            assertThat(factory.getTypeFromInstance(3.2).getClass(), equalTo(Number));
        }

        [Test]
        public function canGetIntTypeFromInstance():void
        {
            var value:int = -11234;
            assertThat(factory.getTypeFromInstance(value).getClass(), equalTo(Number));
        }

        [Test]
        public function canGetUintTypeFromInstance():void
        {
            var value:uint = 15141;
            assertThat(factory.getTypeFromInstance(value).getClass(), equalTo(Number));
        }

        [Test]
        public function canGetArrayTypeFromInstance():void
        {
            var value:Array = [1,2,3,4];
            assertThat(factory.getTypeFromInstance(value), isA(ArrayType));
        }

        [Test]
        public function canGetObjectTypeFromInstance():void
        {
            var value:Object = {hello:"world"};
            assertThat(factory.getTypeFromInstance(value), isA(ObjectType));
        }

        [Test]
        public function canGetVectorTypeFromInstance():void
        {
            var value:Vector.<String> = new <String>["hello"];
            assertThat(factory.getTypeFromInstance(value), isA(VectorType));
        }

        [Test]
        public function vectorTypeFromInstanceCorrectlyNestsElementType():void
        {
            var value:Vector.<String> = new <String>["hello"];
            var type:VectorType = factory.getTypeFromInstance(value) as VectorType;
            assertThat(type.getElementType(), isA(StringType));
        }

        [Test]
        public function canGetClassTypeFromInstance():void
        {
            var object:MockStringWrapper = new MockStringWrapper();
            assertThat(factory.getTypeFromInstance(object), isA(ClassType));
        }

        [Test]
        public function classTypeFromInstanceCorrectlyReferencesClass():void
        {
            var object:MockStringWrapper = new MockStringWrapper();
            assertThat(factory.getTypeFromInstance(object).getClass(), equalTo(MockStringWrapper));
        }
    }
}
