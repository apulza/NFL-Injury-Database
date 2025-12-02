import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

//this script is used in our data collection to merge the player data, give each an id, and create the player on team data

public class NFLRosterMerger {

    private static final String INPUT_DIRECTORY = "./nfl_data";
    private static final String ROSTER_FILE = "roster.csv";
    private static final String PLAYERS_FILE = "players.csv";
    private static int globalPlayerId = 1;
    private static Map<String, Integer> playerMap = new HashMap<>();
    private static List<String> uniquePlayerRecords = new ArrayList<>();

    public static void main(String[] args) {
        File folder = new File(INPUT_DIRECTORY);
        File[] files = folder.listFiles((dir, name) -> name.toLowerCase().endsWith(".csv"));
        try (BufferedWriter rosterWriter = new BufferedWriter(new FileWriter(ROSTER_FILE))) {
            rosterWriter.write("player_id,team,position");
            rosterWriter.newLine();
            for (File file : files) {
                processFile(file, rosterWriter);
            }
            System.out.println("Created roster file: " + ROSTER_FILE);
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        try (BufferedWriter playerWriter = new BufferedWriter(new FileWriter(PLAYERS_FILE))) {
            playerWriter.write("player_id,player_first,player_last,date_of_birth");
            playerWriter.newLine();
            for (String playerRow : uniquePlayerRecords) {
                playerWriter.write(playerRow);
                playerWriter.newLine();
            }
            System.out.println("Created players reference file: " + PLAYERS_FILE);
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void processFile(File file, BufferedWriter rosterWriter) throws IOException {
        String filename = file.getName();
        String teamName = filename.substring(0, filename.lastIndexOf('.'));
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] columns = line.split(",", -1);
                String name = columns[1].trim();
                String position = columns[3].trim();
                String dob = columns[9].trim();
                if (name.equals("Player") || name.equals("Team Total")) {
                    continue;
                }
                String firstName = "";
                String lastName = "";
                if (name.contains(" ")) {
                    int splitIndex = name.indexOf(" ");
                    firstName = name.substring(0, splitIndex);
                    lastName = name.substring(splitIndex + 1);
                }
                else {
                    firstName = name;
                    lastName = ""; 
                }

                String fullNameKey = firstName + " " + lastName;
                int playerId;

                if (playerMap.containsKey(fullNameKey)) {
                    playerId = playerMap.get(fullNameKey);
                }
                else {
                    playerId = globalPlayerId++;
                    playerMap.put(fullNameKey, playerId);
                    String playerEntry = String.format("%d,%s,%s,%s", 
                        playerId, firstName, lastName, dob);
                    uniquePlayerRecords.add(playerEntry);
                }
                String rosterEntry = String.format("%d,%s,%s", playerId, teamName, position);
                rosterWriter.write(rosterEntry);
                rosterWriter.newLine();
            }
        } catch (Exception e) {
            System.err.println("Error processing file: " + file.getName() + " - " + e.getMessage());
        }
    }
}