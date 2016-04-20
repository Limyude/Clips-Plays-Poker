package sample;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import jdk.nashorn.internal.ir.Block;

import javax.xml.bind.ValidationEventLocator;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception{
        // Create a deck of cards
        String pathToFxml = "resources/fxml/sample.fxml";
        FXMLLoader loader = new FXMLLoader(getClass().getClassLoader().getResource(pathToFxml));
        Parent root = loader.load();
        Scene scene = new Scene(root, 1000, 650);
        primaryStage.setScene(scene);
        primaryStage.setTitle("CLIPS Plays Poker - Interface");
        primaryStage.show();
    }


    public static void main(String[] args) {
        System.setProperty("java.library.path", ".");
        launch(args);
    }
}
