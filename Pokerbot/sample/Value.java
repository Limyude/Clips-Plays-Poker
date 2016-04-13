package sample;

/**
 * Created by MOTHERSHIP on 27/3/2016.
 */
public enum Value {
    TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE;

    public static String asString(Value v){
        switch (v){
            case TWO : return "2";
            case THREE : return "3";
            case FOUR : return "4";
            case FIVE : return "5";
            case SIX : return "6";
            case SEVEN : return "7";
            case EIGHT : return "8";
            case NINE : return "9";
            case TEN : return "t";
            case JACK : return "j";
            case QUEEN : return "q";
            case KING : return "k";
            case ACE : return "a";
            default: return "";
        }
    }

    public static Value getNext(Value v){
        switch(v){
            case TWO : return THREE;
            case THREE : return FOUR;
            case FOUR : return FIVE;
            case FIVE : return SIX;
            case SIX : return SEVEN;
            case SEVEN : return EIGHT;
            case EIGHT : return NINE;
            case NINE : return TEN;
            case TEN : return JACK;
            case JACK : return QUEEN;
            case QUEEN : return KING;
            case KING : return ACE;
            case ACE : return TWO;
            default: return null;
        }
    }

    public static int value(Value v){
        switch (v){
            case TWO : return 0;
            case THREE : return 1;
            case FOUR : return 2;
            case FIVE : return 3;
            case SIX : return 4;
            case SEVEN : return 5;
            case EIGHT : return 6;
            case NINE : return 7;
            case TEN : return 8;
            case JACK : return 9;
            case QUEEN : return 10;
            case KING : return 11;
            case ACE : return 12;
            default: return -1;
        }
    }

}
