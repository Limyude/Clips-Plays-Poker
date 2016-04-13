package sample;

/**
 * Created by MOTHERSHIP on 27/3/2016.
 */
public enum Suite {
    SPADE, HEART, DIAMOND, CLUB;

    public static Suite[] ALL_SUITES = {
        SPADE, HEART, DIAMOND, CLUB
    };

    public static String asString(Suite s){
        switch (s){
            case SPADE : return "s";
            case HEART: return "h";
            case DIAMOND: return "d";
            case CLUB: return "c";
            default: return "";
        }
    }

    public static int value(Suite s) {
        switch(s) {
            case CLUB: return 1;
            case DIAMOND: return 2;
            case HEART: return 3;
            case SPADE: return 4;
            default: return -1;
        }
    }
}
