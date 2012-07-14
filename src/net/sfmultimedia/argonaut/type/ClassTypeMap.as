package net.sfmultimedia.argonaut.type
{
    public class ClassTypeMap
    {
        private var properties:Object;
        private var list:Vector.<String>;

        public function ClassTypeMap()
        {
            properties = {};
            list = new Vector.<String>();
        }

        public function getProperties():Vector.<String>
        {
            return list;
        }

        public function getType(property:String):DataType
        {
            return properties[property];
        }

        public function setType(property:String, type:DataType):void
        {
            properties[property] = type;
            if (list.indexOf(property) == -1)
                list.push(property);
        }

    }
}
