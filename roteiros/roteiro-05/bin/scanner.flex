import java_cup.runtime.Symbol;
import java.io.IOException;

%%

%class Scanner
%unicode
%line
%column
%cup

%{
    // Método auxiliar para converter os IDs numéricos do sym em texto puro para o print
    private String getNomeToken(int id) {
        switch (id) {
            case sym.KEY_PROGRAM: return "KEY_PROGRAM";
            case sym.KEY_FINAL:   return "KEY_FINAL";
            case sym.KEY_CLASS:   return "KEY_CLASS";
            case sym.KEY_VOID:    return "KEY_VOID";
            case sym.KEY_IF:      return "KEY_IF";
            case sym.KEY_ELSE:    return "KEY_ELSE";
            case sym.KEY_WHILE:   return "KEY_WHILE";
            case sym.KEY_RETURN:  return "KEY_RETURN";
            case sym.KEY_READ:    return "KEY_READ";
            case sym.KEY_PRINT:   return "KEY_PRINT";
            case sym.KEY_NEW:     return "KEY_NEW";
            case sym.RELOP_EQ:    return "RELOP_EQ";
            case sym.RELOP_NE:    return "RELOP_NE";
            case sym.RELOP_GE:    return "RELOP_GE";
            case sym.RELOP_LE:    return "RELOP_LE";
            case sym.RELOP_GT:    return "RELOP_GT";
            case sym.RELOP_LT:    return "RELOP_LT";
            case sym.ASSIGN:      return "ASSIGN";
            case sym.ADDOP_PLUS:  return "ADDOP_PLUS";
            case sym.ADDOP_MINUS: return "ADDOP_MINUS";
            case sym.MULOP_MULT:  return "MULOP_MULT";
            case sym.MULOP_DIV:   return "MULOP_DIV";
            case sym.MULOP_MOD:   return "MULOP_MOD";
            case sym.LBRACE:      return "LBRACE";
            case sym.RBRACE:      return "RBRACE";
            case sym.LPAREN:      return "LPAREN";
            case sym.RPAREN:      return "RPAREN";
            case sym.LBRACKET:    return "LBRACKET";
            case sym.RBRACKET:    return "RBRACKET";
            case sym.SEMI:        return "SEMI";
            case sym.COMMA:       return "COMMA";
            case sym.DOT:         return "DOT";
            case sym.IDENT:       return "IDENT";
            case sym.INT:         return "INT";
            case sym.FLOAT:       return "FLOAT";
            case sym.CHAR:        return "CHAR";
            case sym.EOF:         return "EOF";
            default:              return "TOKEN_DESCONHECIDO";
        }
    }

    // Método auxiliar modificado para não depender de sym.terminalNames
    private Symbol token(int id, Object value) {
        System.out.printf("[%d,%d] %s: %s%n", (yyline + 1), (yycolumn + 1), getNomeToken(id), yytext());
        return new Symbol(id, yyline, yycolumn, value);
    }
    
    private Symbol token(int id) {
        return token(id, yytext());
    }
%}

Brancos           = [\r\n|\r|\n| \t\f]
Digito            = [0-9]
Letra             = [a-zA-Z]

IntLiteral        = {Digito}+
FloatLiteral      = {Digito}+\.{Digito}+
HexLiteral        = 0x[0-9a-fA-F]+

Ident             = {Letra}({Letra}|{Digito})*
CharConst         = \'[^\'\\]\'

ComentarioLinha   = "//" [^\r\n]*
ComentarioBloco   = "/*" ~"*/"

%%

<YYINITIAL> {
    
    /* Palavras Reservadas */
    "program"           { return token(sym.KEY_PROGRAM); }
    "final"             { return token(sym.KEY_FINAL); }
    "class"             { return token(sym.KEY_CLASS); }
    "void"              { return token(sym.KEY_VOID); }
    "if"                { return token(sym.KEY_IF); }
    "else"              { return token(sym.KEY_ELSE); }
    "while"             { return token(sym.KEY_WHILE); }
    "return"            { return token(sym.KEY_RETURN); }
    "read"              { return token(sym.KEY_READ); }
    "print"             { return token(sym.KEY_PRINT); }
    "new"               { return token(sym.KEY_NEW); }

    /* Operadores Relacionais */
    "=="                { return token(sym.RELOP_EQ); }
    "!="                { return token(sym.RELOP_NE); }
    ">="                { return token(sym.RELOP_GE); }
    "<="                { return token(sym.RELOP_LE); }
    ">"                 { return token(sym.RELOP_GT); }
    "<"                 { return token(sym.RELOP_LT); }
    
    /* Operadores e Atribuição */
    "="                 { return token(sym.ASSIGN); }
    "+"                 { return token(sym.ADDOP_PLUS); }
    "-"                 { return token(sym.ADDOP_MINUS); }
    "*"                 { return token(sym.MULOP_MULT); }
    "/"                 { return token(sym.MULOP_DIV); }
    "%"                 { return token(sym.MULOP_MOD); }
    
    /* Delimitadores */
    "{"                 { return token(sym.LBRACE); }
    "}"                 { return token(sym.RBRACE); }
    "("                 { return token(sym.LPAREN); }
    ")"                 { return token(sym.RPAREN); }
    "["                 { return token(sym.LBRACKET); }
    "]"                 { return token(sym.RBRACKET); }
    ";"                 { return token(sym.SEMI); }
    ","                 { return token(sym.COMMA); }
    "."                 { return token(sym.DOT); }

    /* Literais e Identificadores */
    {HexLiteral}        { return token(sym.INT, yytext()); } 
    {FloatLiteral}      { return token(sym.FLOAT, yytext()); }
    {IntLiteral}        { return token(sym.INT, yytext()); }
    {CharConst}         { return token(sym.CHAR, yytext()); }
    {Ident}             { return token(sym.IDENT, yytext()); }

    /* Ignorados */
    {Brancos}           { /* Ignora */ }
    {ComentarioLinha}   { /* Ignora */ }
    {ComentarioBloco}   { /* Ignora */ }

    /* Erro Léxico */
    .                   { System.err.printf("Erro Lexico na linha %d, coluna %d: Caractere invalido '%s'%n", (yyline+1), (yycolumn+1), yytext()); }
}