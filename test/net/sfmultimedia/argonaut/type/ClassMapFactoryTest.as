package net.sfmultimedia.argonaut.type
{
    import flash.display.Graphics;

    import net.sfmultimedia.argonaut.ArgonautConfig;
    import net.sfmultimedia.argonaut.TestSubClass;
    import net.sfmultimedia.argonaut.TestSuperClass;

    import org.flexunit.assertThat;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.notNullValue;

    public class ClassMapFactoryTest
    {
        private const TESTSUBCLASS_DEFINITION:String = "net.sfmultimedia.argonaut::TestSubClass";
        private const TESTSUPERCLASS_DEFINITION:String = "net.sfmultimedia.argonaut::TestSuperClass";

        private var config:ArgonautConfig;
        private var typeFactory:DataTypeFactory;
        private var factory:ClassMapFactory;

        private var map:ClassTypeMap;

        [Before]
        public function before():void
        {
            var forcesImportOfTestSubClass:TestSubClass;
            var forcesImportOfTestSuperClass:TestSuperClass;

            config = new ArgonautConfig();
            typeFactory = new DataTypeFactory(config);
            factory = new ClassMapFactory(typeFactory);
        }

        private function mapSprite():void
        {
            map = factory.makeClassMap("flash.display::Sprite");
        }

        [Test]
        public function mapsNumericValuesAsNumber():void
        {
            mapSprite();
            assertThat(map.getType("x").getClass(), equalTo(Number));
        }

        [Test]
        public function mapsStringValuesAsString():void
        {
            mapSprite();
            assertThat(map.getType("name"), isA(StringType));
        }

        [Test]
        public function mapsBooleanValuesAsBoolean():void
        {
            mapSprite();
            assertThat(map.getType("cacheAsBitmap").getClass(), equalTo(Boolean));
        }

        [Test]
        public function mapsObjectValuesAsObject():void
        {
            mapSprite();
            assertThat(map.getType("focusRect"),  isA(ObjectType));
        }

        [Test]
        public function mapsTypesToType():void
        {
            mapSprite();
            assertThat(map.getType("graphics"),  isA(ClassType));
        }

        [Test]
        public function mappedTypeHasCorrectTypeValue():void
        {
            mapSprite();
            var type:ClassType = map.getType("graphics") as ClassType;
            assertThat(type.getClass(), equalTo(Graphics));
        }

        [Test]
        public function mapsNumberInTestSubClass():void
        {
            map = factory.makeClassMap(TESTSUBCLASS_DEFINITION);
            assertThat(map.getType("aNumber"), notNullValue());
        }

        [Test]
        public function mapsAllElementsInTestSuperClass():void
        {
            map = factory.makeClassMap(TESTSUPERCLASS_DEFINITION);
            assertThat(map.getProperties().length, equalTo(12));
        }

        [Test]
        public function mapsAllElementsInTestSubClass():void
        {
            map = factory.makeClassMap(TESTSUBCLASS_DEFINITION);
            assertThat(map.getProperties().length, equalTo(16));
        }

    }
}
