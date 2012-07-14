package net.sfmultimedia.argonaut
{
    final public class PrettyPrinter
    {
        private const TAB:String = "   ";
        private const NEWLINE:String = "\n";

        private var source:String;
        private var index:int;
        private var isString:Boolean;
        private var char:String;
        private var indent:int;
        private var pretty:String;

        public function makePretty(json:String):String
        {
            resetFields(json);

            var length:int = json.length;
            for (index = 0; index < length; index++)
            {
                char = json.charAt(index);

                if (char == "\"")
                    addQuotationAndToggleIsString();
                else if (isString)
                    pretty += char;
                else if (isNotWhitespace())
                    handleUsefulCharacters();
            }

            return pretty;
        }

        private function addQuotationAndToggleIsString():void
        {
            if (index > 0 && source.charAt(index - 1) != "\\")
                isString = !isString;

            pretty += "\"";
        }

        private function isNotWhitespace():Boolean
        {
            return char != ' ' && char != "\n" && char != "\t";
        }

        private function handleUsefulCharacters():void
        {
            switch (char)
            {
                case "{":
                case "[":
                    pretty += char + NEWLINE + tabs(++indent);
                    break;
                case "}":
                case "]":
                    pretty += NEWLINE + tabs(--indent) + char;
                    break;
                case ",":
                    pretty += char + NEWLINE + tabs(indent);
                    break;
                case ":":
                    pretty += ": ";
                    break;
                default:
                    pretty += char;
            }
        }

        private function resetFields(json:String):void
        {
            source = json;
            index = 0;
            isString = false;
            indent = 0;
            pretty = "";
        }

        private function tabs(count:int):String
        {
            var str:String = "";
            while (count--)
                str += TAB;

            return str;
        }

    }
}