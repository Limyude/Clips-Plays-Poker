package sample;

/**
 * Created by MOTHERSHIP on 27/3/2016.
 */
public enum Suite {
    SPADE, HEART, DIAMOND, CLUB;

    public static String asString(Suite s){
        switch (s){
            case SPADE : return "s";
            case HEART: return "h";
            case DIAMOND: return "d";
            case CLUB: return "c";
            default: return "";
        }
    }
}
