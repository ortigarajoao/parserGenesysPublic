%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0.5"
%defines
%define parser_class_name {genesyspp_parser} //Name of the parses class
%define api.token.constructor //let that way or change YY_DECL prototype
%define api.value.type variant
%define parse.assert //Checks for constructor and destructor(?)
%code requires
{
#include <string>
#include <cmath>
#include "obj_t.hh"
class genesyspp_driver;
//class obj_t;

}

//%define api.value.type {obj_t} //c++ types for semantic values
 //c++ types for semantic values
// The parsing context.
%param { genesyspp_driver& driver } //aditional params for yylex/yyparse
%locations // allows for more accurate syntax error messages.
%initial-action
{
  // Initialize the initial location.
  @$.begin.filename = @$.end.filename = &driver.file;
};
%define parse.trace //for debugging
%define parse.error verbose //error level to show
%code
{
# include "Genesys++-driver.hh"

}

%token <obj_t> NUMD
%token <obj_t> NUMH
%token <obj_t> NUMB
%token <obj_t> ATRIB
%token <obj_t> VARI
%token <obj_t> FORM
%token <obj_t> QUEUE
%token <obj_t> RES
%token <obj_t> oLE
%token <obj_t> oGE
%token <obj_t> oEQ
%token <obj_t> oNE
%token <obj_t> oAND
%token <obj_t> oOR
%token <obj_t> oNOT
%token <obj_t> fSIN
%token <obj_t> fCOS
%token <obj_t> fAINT
%token <obj_t> fMOD
%token <obj_t> fINT
%token <obj_t> fFRAC
%token <obj_t> fEXPO
%token <obj_t> fNORM
%token <obj_t> fUNIF
%token <obj_t> fWEIB
%token <obj_t> fLOGN
%token <obj_t> fGAMM
%token <obj_t> fERLA
%token <obj_t> fTRIA
%token <obj_t> fBETA
%token <obj_t> fDISC
%token <obj_t> fTNOW
%token <obj_t> fTFIN
%token <obj_t> fNR
%token <obj_t> fMR
%token <obj_t> fIRF
%token <obj_t> fRESSEIZES
%token <obj_t> fSTATE
%token <obj_t> fNQ
%token <obj_t> fFIRSTINQ
%token <obj_t> fLASTINQ
%token <obj_t> cIF
%token <obj_t> cELSE
%token <obj_t> cFOR
%token <obj_t> cTO
%token <obj_t> cDO
%token <obj_t> ILLEGAL     /* illegal token */
%token <obj_t> TESTE
%token LPAREN "("
%token RPAREN ")"
%token PLUS "+"
%token MINUS "-"
%token STAR "*"
%token SLASH "/"
%token LESS "<"
%token GREATER ">"
%token ASSIGN "="
%token COMMA ","
//%token <obj_t> END //EOF
%token END 0 "end of file" //need to declare, as bison doesnt in especific situation

%type <obj_t> tes
%type <obj_t> input
%type <obj_t> programa
%type <obj_t> expressao
%type <obj_t> aritmetica
%type <obj_t> relacional
%type <obj_t> comando
%type <obj_t> comandoIF
%type <obj_t> comandoFOR
%type <obj_t> funcao
%type <obj_t> numero
%type <obj_t> atributo
%type <obj_t> atribuicao
%type <obj_t> variavel
%type <obj_t> formula
%type <obj_t> funcaoTrig
%type <obj_t> funcaoArit
%type <obj_t> funcaoProb
%type <obj_t> funcaoStrc
%type <obj_t> funcaoUser
%type <obj_t> listaparm

%left oNOT
%left oAND oOR
%left oLE oGE oEQ oNE '<' '>'
%left '+' '-'
%left '*' '/'
%left fAINT fMOD fINT fFRAC

%right MINUS

//%printer { yyoutput << $$; } <*>; //prints whren something
%%

input	    : /* empty */
           | input '\n' {YYACCEPT;}
           | input programa                                    { driver.result = $2.valor; std::cout << "Driver.result:" << $2.valor << '\n';}
           | error '\n'                                        { yyerrok; }
           ;

programa   : expressao                                         { $$.valor = $1.valor;                                               std::cout << "Programa:" << $1.valor << '\n';}
     	     ;

expressao   : aritmetica                                        {$$.valor = $1.valor; std::cout << "aritmetica:" << $1.valor << '\n';}
            | relacional                                        {$$.valor = $1.valor; std::cout << "relacional:" << $1.valor << '\n';}
            | "(" expressao ")"                                 { $$.valor = $2.valor;                                               std::cout << $2.valor << '\n';}
            | funcao                                            { $$.valor = $1.valor;                                               std::cout << "Function: " << $1.valor << '\n';}
            | ATRIB                                             { $$.valor = $1.valor;                                               std::cout << "Attribute: " <<$1.valor << '\n';}
            | variavel                                          { $$.valor = $1.valor;                                               std::cout << "Variable: " << $1.valor << '\n';}
            | formula                                           { $$.valor = $1.valor;                                               std::cout << "Formula: " << $1.valor << '\n';}
            | numero                                            { $$.valor = $1.valor;                                               std::cout << "Number: " <<$1.valor << '\n';}
            | comando                                           {}
            ;

numero      : NUMD                                              { $$.valor = $1.valor;                                               std::cout << "Decimal:" << $1.valor << ",Tipo:" << $1.tipo << '\n';}
            | NUMB                                              { $$.valor = $1.valor;                                               std::cout << "Binario:" << $1.valor << '\n';}
            | NUMH                                              { $$.valor = $1.valor;                                               std::cout << "Hexadecimal:" << $1.valor << '\n';}
            ;

aritmetica  : expressao "+" expressao                           { $$.valor = $1.valor + $3.valor;                                    std::cout << $1.valor << " + " << $3.valor << '\n';}
            | expressao "-" expressao                           { $$.valor = $1.valor - $3.valor;                                    std::cout << $1.valor << " - " << $3.valor << '\n';}
            | expressao "/" expressao                           { $$.valor = $1.valor / $3.valor;                                    std::cout << $1.valor << " / " << $3.valor << '\n';}
            | expressao "*" expressao                           { $$.valor = $1.valor * $3.valor;                                    std::cout << $1.valor << " * " << $3.valor << '\n';}
            ;

relacional  : expressao oAND expressao                          { $$.valor = (int) $1.valor && (int) $3.valor;                    	 std::cout << $1.valor << " and " << $3.valor << '\n';}
            | expressao oOR  expressao                          { $$.valor = (int) $1.valor || (int) $3.valor;                       std::cout << $1.valor << " or " << $3.valor << '\n';}
            | expressao "<"  expressao                          { $$.valor = $1.valor < $3.valor ? 1 : 0;														 std::cout << $1.valor << " < " << $3.valor << '\n';}
            | expressao oLE  expressao                          { $$.valor = $1.valor <= $3.valor ? 1 : 0;       										 std::cout << $1.valor << " <= " << $3.valor << '\n';}
            | expressao ">"  expressao                          { $$.valor = $1.valor > $3.valor ? 1 : 0;       										 std::cout << $1.valor << " > " << $3.valor << '\n';}
            | expressao oGE  expressao                          { $$.valor = $1.valor >= $3.valor ? 1 : 0;       										 std::cout << $1.valor << " >= " << $3.valor << '\n';}
            | expressao oEQ  expressao                          { $$.valor = $1.valor == $3.valor ? 1 : 0;       										 std::cout << $1.valor << " ==" << $3.valor << '\n';}
            | expressao oNE  expressao                          { $$.valor = $1.valor != $3.valor ? 1 : 0;       										 std::cout << $1.valor << " !=" << $3.valor << '\n';}
            ;

comando     : comandoIF
            | comandoFOR
            ;

comandoIF   : cIF "(" expressao ")" expressao cELSE expressao   {$$.valor = $3.valor != 0 ? $5.valor : $7.valor;  									 std::cout << "IF "  << $3.valor << " THEN " << $5.valor << " ELSE " << $7.valor  << '\n';}
            | cIF "(" expressao ")" expressao                   {$$.valor = $3.valor != 0 ? $5.valor : 0;        										 std::cout << "IF "  << $3.valor << " THEN " << $5.valor << '\n';}
            ;

comandoFOR  : cFOR variavel "=" expressao cTO expressao cDO atribuicao  {$$.valor = 0; 																							std::cout << "FOR " << $4.valor << " TO " << $6.valor << " DO " << $8.valor << '\n';}
            | cFOR atributo "=" expressao cTO expressao cDO atribuicao  {$$.valor = 0; 																							std::cout << "FOR " << $4.valor << " TO " << $6.valor << " DO " << $8.valor << '\n';}
            ;

funcao      : funcaoArit                                        { $$.valor = $1.valor; }
            | funcaoTrig                                        { $$.valor = $1.valor; }
            | funcaoProb                                        { $$.valor = $1.valor; }
            | funcaoStrc                                        { $$.valor = $1.valor; }
            | funcaoUser                                        { $$.valor = $1.valor; }
            ;



atributo    : ATRIB                                             { $$.valor = $1.valor; }
            ;

atribuicao  : atributo "=" expressao                            { $$.valor = $3.valor; }
            | variavel "=" expressao                            { $$.valor = $3.valor; }
            ;

variavel    : NUMD                                              { $$.valor = $1.valor;} //change
            ;

formula     : NUMD                                              { $$.valor = $1.valor;} //change
            ;

funcaoTrig  : fSIN   "(" expressao ")"                          { $$.valor = sin($3.valor);                                         std::cout << "Sin(" << $3.valor << "):" << $$.valor << '\n';}
            | fCOS   "(" expressao ")"                          { $$.valor = cos($3.valor); 																				std::cout << "Cos(" << $3.valor << "):" << $$.valor << '\n';}
            ;

funcaoArit  : fAINT  "(" expressao ")"                          { $$.valor = (int) $3.valor;}
            | fFRAC  "(" expressao ")"                          { $$.valor = $3.valor - (int) $3.valor;}
            | fINT   "(" expressao ")"                          { $$.valor = (int) $3.valor;}
            | fMOD   "(" expressao "," expressao ")"            { $$.valor = (int) $3.valor % (int) $5.valor; }
            ;

funcaoProb  : fEXPO  "(" expressao ")"                                            { $$.valor = 0; $$.tipo = "Exponencial"; std::cout << "Exponencial" << '\n';}
            | fNORM  "(" expressao "," expressao ")"                              { $$.valor = 0; $$.tipo = "Normal"; }
            | fUNIF  "(" expressao "," expressao ")"                              { $$.valor = 0; $$.tipo = "Unificada"; }
            | fWEIB  "(" expressao "," expressao ")"                              { $$.valor = 0; $$.tipo = "Weibull"; }
            | fLOGN  "(" expressao "," expressao ")"                              { $$.valor = 0; $$.tipo = "LOGNormal"; }
            | fGAMM  "(" expressao "," expressao ")"                              { $$.valor = 0; $$.tipo = "Gamma"; }
            | fERLA  "(" expressao "," expressao ")"                              { $$.valor = 0; $$.tipo = "Erlang"; }
            | fTRIA  "(" expressao "," expressao "," expressao ")"                { $$.valor = 0; $$.tipo = "Triangular"; }
            | fBETA  "(" expressao "," expressao "," expressao "," expressao ")"  { $$.valor = 0; $$.tipo = "Beta"; }
            | fDISC  "(" listaparm ")"
            ;

funcaoStrc  : NUMD                                              { $$.valor = $1.valor;}
            ;

funcaoUser  : "USER" "(" expressao ")"                          { $$.valor = $3.valor; }
            ;

listaparm   : listaparm "," expressao "," expressao
            | expressao "," expressao
            ;


tes       : TESTE { std::cout << "Valor:" << $$.valor << ", Tipo:" << $$.tipo << '\n';}
          | NUMD  { driver.result = $1.valor; std::cout << "Valor:" << $1.valor << ", Tipo:" << $1.tipo << '\n';}
          ;


%%
void
yy::genesyspp_parser::error (const location_type& l,
                          const std::string& m)
{
  driver.error (l, m);
}
