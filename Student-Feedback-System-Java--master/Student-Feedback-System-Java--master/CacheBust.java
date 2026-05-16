import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;

public class CacheBust {
    public static void main(String[] args) throws Exception {
        Files.walk(Paths.get("WebContent/WEB-INF/views"))
             .filter(p -> p.toString().endsWith(".jsp"))
             .forEach(p -> {
                 try {
                     String content = new String(Files.readAllBytes(p));
                     content = content.replaceAll("style\\.css([^\"']*)", "style.css?v=" + System.currentTimeMillis());
                     Files.write(p, content.getBytes());
                     System.out.println("Updated " + p);
                 } catch(Exception e) {}
             });
    }
}
