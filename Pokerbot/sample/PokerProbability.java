package sample;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

public class PokerProbability {

  private static final int HAND_RANK_SIZE   = 32487834;
  private static final String HAND_RANK_FILE  = "HandRanks.dat";

  private static final int AHEAD        = 0;
  private static final int TIED       = 1;
  private static final int BEHIND       = 2;

  private static final int PUBLIC_CARDS   = 5;
  private static final int TURN       = 4;

  private static final int OPP_CARD_1_POS = 5;
  private static final int OPP_CARD_2_POS = 6;
  private static final int RIVER_POS    = 7;
  private static final int TURN_POS   = 8;

  private int[] HandRanks;

  /*
   * Constructor
   * */

  public PokerProbability() {
    HandRanks = new int[HAND_RANK_SIZE];
    loadHandRanks();
  }


  /*
   * Calculate the poker's winning probability
   * Input:
   *    Array of player's cards,
   *    Array of community cards
   *    Number of opponents
   * Output:
   *    winning probability (0-1)
   * */

  public double calculateWinningProbability(Card[] playerCards, ArrayList<Card> publicCardsList,
      int numOpponents) {

    Card[] publicCards = publicCardsList.toArray(new Card[publicCardsList.size()]);
    int[] intPlayerCards = intCards(playerCards);
    int[] intPublicCards = intCards(publicCards);

    double handStrength = calculateHandStrength(intPlayerCards, intPublicCards, numOpponents);
    double[] handPotential = calculateHandPotential(intPlayerCards, intPublicCards, numOpponents);
    double PPot = handPotential[0];
    double NPot = handPotential[1];

    double winningProbability = handStrength * (1 - NPot) + (1 - handStrength) * PPot;

    return winningProbability;
  }


  /*
   * Calculate the poker's hand strength
   *
   * Input:
   *    Array of player's cards
   *    Array of community cards
   *    Number of opponents
   * Output:
   *    Hand strength (0-1)
   *
   * */

  private double calculateHandStrength(int[] playerCards, int[] publicCards,
      int numOpponents) {
    double handStrength = oneOpponentHandStrength(playerCards, publicCards);
    return Math.pow(handStrength, numOpponents);
  }

  private double oneOpponentHandStrength(int[] playerCards, int[] publicCards) {
    double handStrength = 0;
    int ahead = 0, tied = 0, behind = 0;
    int[] opponentCards = new int[2];
    ArrayList<Integer> seenCards = new ArrayList<>(5);
    int count = 0;

    // initialize
    for(int playerCard : playerCards)
      seenCards.add(playerCard);
    for(int publicCard : publicCards)
      seenCards.add(publicCard);

    // start of algorithm
    int playerRank = handRank(playerCards, publicCards);

    // exhaust all possibilities of opponent's cards
    for(int card1=Card.MIN_VAL; card1<=Card.MAX_VAL-1; card1++) {
      for(int card2 = card1+1; card2<=Card.MAX_VAL; card2++) {
        if(!seenCards.contains(card1) && !seenCards.contains(card2)) {

          System.out.println(card1 + ", " + card2);

          // adding opponent cards
          opponentCards[0] = card1;
          opponentCards[1] = card2;

          // compare between player's best hand and opponent's best hand
          int opponentRank = handRank(opponentCards, publicCards);
          if(playerRank > opponentRank)       ahead++;
          else if(playerRank == opponentRank)   tied++;
          else if(playerRank < opponentRank)    behind++;

          count++;

        }
      }
    }

    handStrength = (ahead + tied/2.0f) / (double) (ahead + tied + behind);

    System.out.println("HandStrength: " + ahead + " " + tied + " " + behind + " " + count);

    return handStrength;
  }


  /*
   * Calculate the poker's hand potential
   *
   * Input:
   *    Array of player's cards
   *    Array of community cards
   *    Number of opponents
   * Output:
   *    An array of doubles of PPot and NPot
   *    PPot: probability that your hand is bad but turns out better in the future (0-1)
   *    NPot: probability that your hand is good but turns out worse in the future (0-1)
   *
   * */

  private double[] calculateHandPotential(int[] playerCards, int[] publicCards,
      int numOpponents) {
    double[] handPotential = oneOpponentHandPotential(playerCards, publicCards);
    double PPot = Math.pow(handPotential[0], numOpponents);
    double NPot = Math.pow(handPotential[1], numOpponents);

    return new double[] {PPot, NPot};
  }

  private double[] oneOpponentHandPotential(int[] playerCards, int[] publicCards) {
    double PPot = 0.0f, NPot = 0.0f;
    int[] HPTotal = new int[3];
    int[][] HP = new int[3][3];
    int[] opponentCards = new int[2];
    int[] possiblePublicCards = new int[PUBLIC_CARDS];
    ArrayList<Integer> seenCards = new ArrayList<>(9);
    int count = 0;

    // initialize
    for(int i=0; i<3; i++)
      Arrays.fill(HP[i], 0);

    Arrays.fill(HPTotal, 0);

    for(int playerCard : playerCards)
      seenCards.add(playerCard);
    for(int publicCard : publicCards)
      seenCards.add(publicCard);
    seenCards.add(-1);
    seenCards.add(-1);

    for(int i=0; i<publicCards.length; i++)
      possiblePublicCards[i] = publicCards[i];


    // start of algorithm
    int playerRank = handRank(playerCards, publicCards);

    // exhaust all possibilities of opponent's cards
    for(int card1=Card.MIN_VAL; card1<=Card.MAX_VAL-1; card1++) {
      for(int card2 = card1+1; card2<=Card.MAX_VAL; card2++) {
        if(!seenCards.contains(card1) && !seenCards.contains(card2)) {
          int index = -1;

          // adding opponent cards
          opponentCards[0] = card1;
          opponentCards[1] = card2;

          seenCards.add(OPP_CARD_1_POS,card1);
          seenCards.add(OPP_CARD_2_POS, card2);

          // compare between player's best hand and opponent's best hand
          int opponentRank = handRank(opponentCards, publicCards);
          if(playerRank > opponentRank)       index = AHEAD;
          else if(playerRank == opponentRank)   index = TIED;
          else if(playerRank < opponentRank)    index = BEHIND;

          count++;

          // exhaust all possibilities of future public cards
          if(publicCards.length < TURN) {

            for(int card3=Card.MIN_VAL; card3<=Card.MAX_VAL-1; card3++) {
              for(int card4=card3+1; card4<=Card.MAX_VAL; card4++) {
                if(!seenCards.contains(card3) && !seenCards.contains(card4)) {
                  seenCards.add(TURN_POS, card3);
                  seenCards.add(RIVER_POS, card4);
                  possiblePublicCards[3] = card3;
                  possiblePublicCards[4] = card4;

                  int futurePlayerRank = handRank(playerCards, possiblePublicCards);
                  int futureOpponentRank = handRank(opponentCards, possiblePublicCards);

                  if(futurePlayerRank > futureOpponentRank)     HP[index][AHEAD]++;
                  else if(futurePlayerRank == futureOpponentRank) HP[index][TIED]++;
                  else if(futurePlayerRank < futureOpponentRank)  HP[index][BEHIND]++;

                  HPTotal[index]++;

                  seenCards.remove(TURN_POS);
                  seenCards.remove(RIVER_POS);
                }
              }
            }

          } else {

            for(int card3=Card.MIN_VAL; card3<=Card.MAX_VAL; card3++) {
              if(!seenCards.contains(card3)) {
                seenCards.add(RIVER_POS, card3);
                possiblePublicCards[4] = card3;

                int futurePlayerRank = handRank(playerCards, possiblePublicCards);
                int futureOpponentRank = handRank(opponentCards, possiblePublicCards);

                if(futurePlayerRank > futureOpponentRank)   HP[index][AHEAD]++;
                else if(futurePlayerRank == futureOpponentRank) HP[index][TIED]++;
                else if(futurePlayerRank < futureOpponentRank)  HP[index][BEHIND]++;

                HPTotal[index]++;

                seenCards.remove(RIVER_POS);
              }
            }

          }

          seenCards.remove(OPP_CARD_1_POS);
          seenCards.remove(OPP_CARD_2_POS);
        }
      }
    }

    PPot = (HP[BEHIND][AHEAD] + HP[BEHIND][TIED]/2.0f + HP[TIED][AHEAD]/2.0f) /
        (double) (HPTotal[BEHIND] + HPTotal[TIED]/2.0f);
    NPot = (HP[AHEAD][BEHIND] + HP[TIED][BEHIND]/2.0f + HP[AHEAD][TIED]/2.0f) /
        (double) (HPTotal[AHEAD] + HPTotal[TIED]/2.0f);

    System.out.println(PPot + " " + NPot + " " + count);

    return new double[] {PPot, NPot};
  }


  /*
   * Rank player's card
   *
   * Input:
   *    An array of all seen cards
   * Output:
   *    rank (an integer)
   *
   * Algorithm:
   *    TwoPlusTwoEvaluator
   * */
  private int handRank(int[] playerCards, int[] publicCards) {
    int rank = 53;
    int[] seenCards = concat(playerCards, publicCards);

    for(int index = 0; index<seenCards.length; index++) {
      rank = HandRanks[rank + seenCards[index]];
    }

    return rank;
  }

  private void loadHandRanks() {
    int tableSize = HAND_RANK_SIZE * 4;
    byte[] bTable = new byte[tableSize];
    BufferedInputStream br = null;

    try {
      br = new BufferedInputStream(new FileInputStream(HAND_RANK_FILE));
      int bytesRead = br.read(bTable, 0, tableSize);
            if (bytesRead != tableSize) {
                System.err.println("file bytes read is different from: " + tableSize);
            }

    } catch(Exception e) {
      System.err.println("Exception: " + e.getMessage());
    } finally {
      try {
        br.close();
      } catch (IOException e) {
        e.printStackTrace();
      }

      for (int i = 0; i < HAND_RANK_SIZE; i++) {
              HandRanks[i] = littleEndianByteArrayToInt(bTable, i * 4);
          }
    }
  }

  private int littleEndianByteArrayToInt(byte[] b, int offset) {
        return (b[offset + 3] << 24) + ((b[offset + 2] & 0xFF) << 16)
                + ((b[offset + 1] & 0xFF) << 8) + (b[offset] & 0xFF);
    }


  /*
   * Helper function
   * */

  private int[] concat(int[] playerCards, int[] publicCards) {
    int[] concat = new int[playerCards.length + publicCards.length];

    System.arraycopy(playerCards, 0, concat, 0, playerCards.length);
        System.arraycopy(publicCards, 0, concat, playerCards.length, publicCards.length);

    return concat;
  }

  private int[] intCards(Card[] cards) {
    int[] intCards = new int[cards.length];
    for(int i=0; i<cards.length; i++)
      intCards[i] = cards[i].getValue();

    return intCards;
  }

}