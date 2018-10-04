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
# include "obj_t.hh"
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
//%token <obj_t> END //EOF
%token END 0 "end of file"

%type <obj_t> tes
%type <obj_t> programa
%type <obj_t> expressao
%type <obj_t> aritmetica
%type <obj_t> relacional
%type <obj_t> funcao
%type <obj_t> numero
%type <obj_t> funcaoTrig
%type <obj_t> funcaoArit

%left oNOT
%left oAND oOR
%left oLE oGE oEQ oNE '<' '>'
%left '+' '-'
%left '*' '/'
%left fAINT fMOD fINT fFRAC

%right UMINUS

//%printer { yyoutput << $$; } <*>; //prints whren something
%%



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
