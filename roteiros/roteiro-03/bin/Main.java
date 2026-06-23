import java.io.FileReader;
import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        // Se você digitar um nome de arquivo no terminal, ele usa. Se não, usa o entrada.txt padrão.
        String nomeArquivo = (args.length > 0) ? args[0] : "entrada.txt";

        System.out.println("--- Iniciando Analise Lexica e Sintatica ---");
        System.out.println("Lendo o arquivo: " + nomeArquivo);
        System.out.println("--------------------------------------------");

        try {
            // Abre o arquivo escolhido
            Scanner scanner = new Scanner(new FileReader(nomeArquivo));
            parser p = new parser(scanner);
            
            // Faz a análise sintática (que automaticamente vai puxando os tokens do scanner)
            p.parse();
            
            System.out.println("--------------------------------------------");
            System.out.println("--- Analise Concluida com SUCESSO! ---");
        } catch (IOException e) {
            System.err.println("Erro ao abrir o arquivo: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("--------------------------------------------");
            System.err.println("--- Analise interrompida devido a erros ---");
        }
    }
}