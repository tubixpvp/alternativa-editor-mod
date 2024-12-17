package alternativa.utils
{
   import flash.utils.Dictionary;
   
   public class KeyboardUtils
   {
      private static var keyCodeStringRepresentation:Dictionary;
      
      public static const A:uint = 65;
      
      public static const B:uint = 66;
      
      public static const C:uint = 67;
      
      public static const D:uint = 68;
      
      public static const E:uint = 69;
      
      public static const F:uint = 70;
      
      public static const G:uint = 71;
      
      public static const H:uint = 72;
      
      public static const I:uint = 73;
      
      public static const J:uint = 74;
      
      public static const K:uint = 75;
      
      public static const L:uint = 76;
      
      public static const M:uint = 77;
      
      public static const N:uint = 78;
      
      public static const O:uint = 79;
      
      public static const P:uint = 80;
      
      public static const Q:uint = 81;
      
      public static const R:uint = 82;
      
      public static const S:uint = 83;
      
      public static const T:uint = 84;
      
      public static const U:uint = 85;
      
      public static const V:uint = 86;
      
      public static const W:uint = 87;
      
      public static const X:uint = 88;
      
      public static const Y:uint = 89;
      
      public static const Z:uint = 90;
      
      public static const SPACE:uint = 32;
      
      public static const SEMICOLON:uint = 186;
      
      public static const COMMA:uint = 188;
      
      public static const PERIOD:uint = 190;
      
      public static const SLASH:uint = 191;
      
      public static const BACKQUOTE:uint = 192;
      
      public static const LEFTBRACKET:uint = 219;
      
      public static const BACKSLASH:uint = 220;
      
      public static const RIGHTBRACKET:uint = 221;
      
      public static const QUOTE:uint = 222;
      
      public static const BACKSPACE:uint = 8;
      
      public static const TAB:uint = 9;
      
      public static const PAGE_UP:uint = 33;
      
      public static const PAGE_DOWN:uint = 34;
      
      public static const END:uint = 35;
      
      public static const HOME:uint = 36;
      
      public static const INSERT:uint = 45;
      
      public static const DELETE:uint = 46;
      
      public static const NUMBER_0:uint = 48;
      
      public static const NUMBER_1:uint = 49;
      
      public static const NUMBER_2:uint = 50;
      
      public static const NUMBER_3:uint = 51;
      
      public static const NUMBER_4:uint = 52;
      
      public static const NUMBER_5:uint = 53;
      
      public static const NUMBER_6:uint = 54;
      
      public static const NUMBER_7:uint = 55;
      
      public static const NUMBER_8:uint = 56;
      
      public static const NUMBER_9:uint = 57;
      
      public static const EQUAL:uint = 187;
      
      public static const MINUS:uint = 189;
      
      public static const NUMPAD:uint = 21;
      
      public static const NUMPAD_0:uint = 96;
      
      public static const NUMPAD_1:uint = 97;
      
      public static const NUMPAD_2:uint = 98;
      
      public static const NUMPAD_3:uint = 99;
      
      public static const NUMPAD_4:uint = 100;
      
      public static const NUMPAD_5:uint = 101;
      
      public static const NUMPAD_6:uint = 102;
      
      public static const NUMPAD_7:uint = 103;
      
      public static const NUMPAD_8:uint = 104;
      
      public static const NUMPAD_9:uint = 105;
      
      public static const NUMPAD_ADD:uint = 107;
      
      public static const NUMPAD_DECIMAL:uint = 110;
      
      public static const NUMPAD_DIVIDE:uint = 111;
      
      public static const NUMPAD_ENTER:uint = 108;
      
      public static const NUMPAD_MULTIPLY:uint = 106;
      
      public static const NUMPAD_SUBTRACT:uint = 109;
      
      public static const ENTER:uint = 13;
      
      public static const COMMAND:uint = 15;
      
      public static const SHIFT:uint = 16;
      
      public static const CONTROL:uint = 17;
      
      public static const CAPS_LOCK:uint = 20;
      
      public static const ESCAPE:uint = 27;
      
      public static const LEFT:uint = 37;
      
      public static const UP:uint = 38;
      
      public static const RIGHT:uint = 39;
      
      public static const DOWN:uint = 40;
      
      public static const F1:uint = 112;
      
      public static const F2:uint = 113;
      
      public static const F3:uint = 114;
      
      public static const F4:uint = 115;
      
      public static const F5:uint = 116;
      
      public static const F6:uint = 117;
      
      public static const F7:uint = 118;
      
      public static const F8:uint = 119;
      
      public static const F9:uint = 120;
      
      public static const F10:uint = 121;
      
      public static const F11:uint = 122;
      
      public static const F12:uint = 123;
      
      public static const F13:uint = 124;
      
      public static const F14:uint = 125;
      
      public static const F15:uint = 126;
      
      public function KeyboardUtils()
      {
         super();
      }
      
      private static function fillKeyCodes() : void
      {
         keyCodeStringRepresentation = new Dictionary(true);
         keyCodeStringRepresentation[A] = "A";
         keyCodeStringRepresentation[B] = "B";
         keyCodeStringRepresentation[C] = "C";
         keyCodeStringRepresentation[D] = "D";
         keyCodeStringRepresentation[E] = "E";
         keyCodeStringRepresentation[F] = "F";
         keyCodeStringRepresentation[G] = "G";
         keyCodeStringRepresentation[H] = "H";
         keyCodeStringRepresentation[I] = "I";
         keyCodeStringRepresentation[J] = "J";
         keyCodeStringRepresentation[K] = "K";
         keyCodeStringRepresentation[L] = "L";
         keyCodeStringRepresentation[M] = "M";
         keyCodeStringRepresentation[N] = "N";
         keyCodeStringRepresentation[O] = "O";
         keyCodeStringRepresentation[P] = "P";
         keyCodeStringRepresentation[Q] = "Q";
         keyCodeStringRepresentation[R] = "R";
         keyCodeStringRepresentation[S] = "S";
         keyCodeStringRepresentation[T] = "T";
         keyCodeStringRepresentation[U] = "U";
         keyCodeStringRepresentation[V] = "V";
         keyCodeStringRepresentation[W] = "W";
         keyCodeStringRepresentation[X] = "X";
         keyCodeStringRepresentation[Y] = "Y";
         keyCodeStringRepresentation[Z] = "Z";
         keyCodeStringRepresentation[SPACE] = "SPACE";
         keyCodeStringRepresentation[SEMICOLON] = "SEMICOLON";
         keyCodeStringRepresentation[COMMA] = "COMMA";
         keyCodeStringRepresentation[PERIOD] = "PERIOD";
         keyCodeStringRepresentation[SLASH] = "SLASH";
         keyCodeStringRepresentation[BACKQUOTE] = "BACK QUOTE";
         keyCodeStringRepresentation[LEFTBRACKET] = "LEFT BRACKET";
         keyCodeStringRepresentation[BACKSLASH] = "BACK SLASH";
         keyCodeStringRepresentation[RIGHTBRACKET] = "RIGHT BRACKET";
         keyCodeStringRepresentation[QUOTE] = "\'";
         keyCodeStringRepresentation[BACKSPACE] = "BACKSPACE";
         keyCodeStringRepresentation[TAB] = "TAB";
         keyCodeStringRepresentation[PAGE_UP] = "PAGE UP";
         keyCodeStringRepresentation[PAGE_DOWN] = "PAGE DOWN";
         keyCodeStringRepresentation[END] = "END";
         keyCodeStringRepresentation[HOME] = "HOME";
         keyCodeStringRepresentation[INSERT] = "INSERT";
         keyCodeStringRepresentation[DELETE] = "DELETE";
         keyCodeStringRepresentation[NUMBER_0] = "0";
         keyCodeStringRepresentation[NUMBER_1] = "1";
         keyCodeStringRepresentation[NUMBER_2] = "2";
         keyCodeStringRepresentation[NUMBER_3] = "3";
         keyCodeStringRepresentation[NUMBER_4] = "4";
         keyCodeStringRepresentation[NUMBER_5] = "5";
         keyCodeStringRepresentation[NUMBER_6] = "6";
         keyCodeStringRepresentation[NUMBER_7] = "7";
         keyCodeStringRepresentation[NUMBER_8] = "8";
         keyCodeStringRepresentation[NUMBER_9] = "9";
         keyCodeStringRepresentation[EQUAL] = "EQUAL";
         keyCodeStringRepresentation[MINUS] = "MINUS";
         keyCodeStringRepresentation[NUMPAD] = "NUM LOCK";
         keyCodeStringRepresentation[NUMPAD_0] = "0";
         keyCodeStringRepresentation[NUMPAD_1] = "1";
         keyCodeStringRepresentation[NUMPAD_2] = "2";
         keyCodeStringRepresentation[NUMPAD_3] = "3";
         keyCodeStringRepresentation[NUMPAD_4] = "4";
         keyCodeStringRepresentation[NUMPAD_5] = "5";
         keyCodeStringRepresentation[NUMPAD_6] = "6";
         keyCodeStringRepresentation[NUMPAD_7] = "7";
         keyCodeStringRepresentation[NUMPAD_8] = "8";
         keyCodeStringRepresentation[NUMPAD_9] = "9";
         keyCodeStringRepresentation[NUMPAD_ADD] = "NUM+";
         keyCodeStringRepresentation[NUMPAD_DECIMAL] = "NUM DECIMAL";
         keyCodeStringRepresentation[NUMPAD_DIVIDE] = "NUM DIVIDE";
         keyCodeStringRepresentation[NUMPAD_ENTER] = "NUMPAD ENTER";
         keyCodeStringRepresentation[NUMPAD_MULTIPLY] = "NUM MULTIPLY";
         keyCodeStringRepresentation[NUMPAD_SUBTRACT] = "NUM SUBTRACT";
         keyCodeStringRepresentation[ENTER] = "ENTER";
         keyCodeStringRepresentation[COMMAND] = "COMMAND";
         keyCodeStringRepresentation[SHIFT] = "SHIFT";
         keyCodeStringRepresentation[CONTROL] = "CONTROL";
         keyCodeStringRepresentation[CAPS_LOCK] = "CAPS LOCK";
         keyCodeStringRepresentation[ESCAPE] = "ESCAPE";
         keyCodeStringRepresentation[LEFT] = "LEFT";
         keyCodeStringRepresentation[UP] = "UP";
         keyCodeStringRepresentation[RIGHT] = "RIGHT";
         keyCodeStringRepresentation[DOWN] = "DOWN";
         keyCodeStringRepresentation[F1] = "F1";
         keyCodeStringRepresentation[F2] = "F2";
         keyCodeStringRepresentation[F3] = "F3";
         keyCodeStringRepresentation[F4] = "F4";
         keyCodeStringRepresentation[F5] = "F5";
         keyCodeStringRepresentation[F6] = "F6";
         keyCodeStringRepresentation[F7] = "F7";
         keyCodeStringRepresentation[F8] = "F8";
         keyCodeStringRepresentation[F9] = "F9";
         keyCodeStringRepresentation[F10] = "F10";
         keyCodeStringRepresentation[F11] = "F11";
         keyCodeStringRepresentation[F12] = "F12";
         keyCodeStringRepresentation[F13] = "F13";
         keyCodeStringRepresentation[F14] = "F14";
         keyCodeStringRepresentation[F15] = "F15";
      }
      
      public static function getKeyCodeStringRepresentation(param1:uint) : String
      {
         if(keyCodeStringRepresentation == null)
         {
            fillKeyCodes();
         }
         return keyCodeStringRepresentation[param1];
      }
   }
}

