package sample;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;

public class PokerProbability {

  private static final int HAND_RANK_SIZE   = 32487834;
  private static final String HAND_RANK_FILE  = "HandRanks.dat";

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

  public double calculateWinningProbability(Card[] playerCards, ArrayList<Card> publicCards,
      int numOpponents) {

    double handStrength = calculateHandStrength(playerCards, publicCards, numOpponents);
    double[] handPotential = calculateHandPotential(playerCards, publicCards, numOpponents);
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

  private double calculateHandStrength(Card[] playerCards, ArrayList<Card> publicCards,
      int numOpponents) {
    double handStrength = oneOpponentHandStrength(playerCards, publicCards);
    return Math.pow(handStrength, numOpponents);
  }

  private static double oneOpponentHandStrength(Card[] playerCards, ArrayList<Card> publicCards) {
    double handStrength = 0;

    // fill in code

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

  private double[] calculateHandPotential(Card[] playerCards, ArrayList<Card> publicCards,
      int numOpponents) {
    double[] handPotential = oneOpponentHandPotential(playerCards, publicCards);
    double PPot = Math.pow(handPotential[0], numOpponents);
    double NPot = Math.pow(handPotential[1], numOpponents);

    return new double[] {PPot, NPot};
  }

  private double[] oneOpponentHandPotential(Card[] playerCards, ArrayList<Card> publicCards) {
    double PPot = 0.0f, NPot = 0.0f;

    // fill in code

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
  private int rank(Card[] seenCards) {
    int rank = 53;

    for(int index = 0; index<seenCards.length; index++) {
      rank = HandRanks[rank + seenCards[index].getValue()];
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

}