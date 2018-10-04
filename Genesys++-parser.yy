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
%token <obj_t> END //EOF

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



input	    : /* empty */
           | input '\n' {YYACCEPT;}
           | input programa
           | error '\n'                                        { yyerrok; }
           ;

tes       : TESTE {$$.valor = $1.valor; std::cout << "Certo";}
          ;

/*programa   : expressao                                         { $$.valor = $1.valor;                                               fprintf(yyoutput, "%g", $1.valor);}
      	    ;
*/

/*expressao  : aritmetica
           | relacional
           | '(' expressao ')'                                 { $$.valor = $2.valor;                                               fprintf(yyoutput, "(%g)", $1.valor);}
		   		 | funcao                                            { $$.valor = $1.valor;                                               fprintf(yyoutput, "Function:%g", $1.valor);}
           | ATRIB                                             { $$.valor = $1.valor;                                               fprintf(yyoutput, "Attribute:%g", $1.valor);}
           | variavel                                          { $$.valor = $1.valor;                                               fprintf(yyoutput, "Variable:%g", $1.valor);}
           | formula                                           { $$.valor = $1.valor;                                               fprintf(yyoutput, "Formula:%g", $1.valor);}
           | numero                                            { $$.valor = $1.valor;                                               fprintf(yyoutput, "Number:%g", $1.valor);}
		   		 | comando
           ;
*/

/*expressao  : aritmetica
           | relacional
           | '(' expressao ')'                                 { $$.valor = $2.valor;                                               fprintf(stdout, "(%g)", $1.valor);}
		   		 | funcao                                            { $$.valor = $1.valor;                                               fprintf(yyoutput, "Function:%g", $1.valor);}
           | ATRIB                                             { $$.valor = $1.valor;                                               fprintf(yyoutput, "Attribute:%g", $1.valor);}
           | variavel                                          { $$.valor = $1.valor;                                               fprintf(yyoutput, "Variable:%g", $1.valor);}
           | numero                                            { $$.valor = $1.valor;                                               fprintf(yyoutput, "Number:%g", $1.valor);}
		   		 | comando
           ;
*/

/*
expressao  : aritmetica
           | relacional
           | '(' expressao ')'                                 { $$.valor = $2.valor;                                               fprintf(stdout, "(%g)", $2.valor);}
		   		 | funcao                                            { $$.valor = $1.valor;                                               fprintf(stdout, "Function:%g", $1.valor);}
           | ATRIB                                             { $$.valor = $1.valor;                                               fprintf(stdout, "Attribute:%g", $1.valor);}
           | numero                                            { $$.valor = $1.valor;                                               fprintf(stdout, "Number:%g", $1.valor);}
           ;

*/

/*
aritmetica : expressao '+' expressao                           { $$.valor = $1.valor + $3.valor;                                    fprintf(stdout, "%g + %g", $1.valor, $3.valor);}
           | expressao '-' expressao                           { $$.valor = $1.valor - $3.valor;                                    fprintf(stdout, "%g - %g", $1.valor, $3.valor);}
           | expressao '/' expressao                           { $$.valor = $1.valor / $3.valor;                                    fprintf(stdout, "%g / %g", $1.valor, $3.valor);}
           | expressao '*' expressao                           { $$.valor = $1.valor * $3.valor;                                    fprintf(stdout, "%g * %g", $1.valor, $3.valor);}
           ;
*/

/*
relacional : expressao oAND expressao                          { $$.valor = (int) $1.valor && (int) $3.valor;                    		fprintf(stdout, "%g and %g", $1.valor, $3.valor);}
           | expressao oOR  expressao                          { $$.valor = (int) $1.valor || (int) $3.valor;                       fprintf(stdout, "%g or %g", $1.valor, $3.valor);}
           | expressao '<'  expressao                          { $$.valor = $1.valor < $3.valor ? 1 : 0;														fprintf(stdout, "%g < %g", $1.valor, $3.valor);}
           | expressao oLE  expressao                          { $$.valor = $1.valor <= $3.valor ? 1 : 0;       										fprintf(stdout, "%g <= %g", $1.valor, $3.valor);}
           | expressao '>'  expressao                          { $$.valor = $1.valor > $3.valor ? 1 : 0;       											fprintf(stdout, "%g > %g", $1.valor, $3.valor);}
           | expressao oGE  expressao                          { $$.valor = $1.valor >= $3.valor ? 1 : 0;       										fprintf(stdout, "%g >= %g", $1.valor, $3.valor);}
           | expressao oEQ  expressao                          { $$.valor = $1.valor == $3.valor ? 1 : 0;       										fprintf(stdout, "%g == %g", $1.valor, $3.valor);}
           | expressao oNE  expressao                          { $$.valor = $1.valor != $3.valor ? 1 : 0;       										fprintf(stdout, "%g != %g", $1.valor, $3.valor);}
           ;
*/

/*comando    : comandoIF
           | comandoFOR
           ;

comandoIF  : cIF '(' expressao ')' expressao cELSE expressao   {$$.valor = $3.valor != 0 ? $5.valor : $7.valor;  										fprintf(yyoutput, "IF %g THEN %g ELSE %g", $3.valor, $5.valor, $7.valor);}
           | cIF '(' expressao ')' expressao                   {$$.valor = $3.valor != 0 ? $5.valor : 0;        										fprintf(yyoutput, "IF %g THEN %g", $3.valor, $5.valor);}
           ;

comandoFOR : cFOR variavel '=' expressao cTO expressao cDO atribuicao  {$$.valor = 0; 																							fprintf(yyoutput, "FOR %g TO %g DO %g", $4.valor, $6.valor, $8.valor);}
           | cFOR atributo '=' expressao cTO expressao cDO atribuicao  {$$.valor = 0; 																							fprintf(yyoutput, "FOR %g TO %g DO %g", $4.valor, $6.valor, $8.valor);}
						;

*/

/*funcao     : funcaoArit                                        { $$.valor = $1.valor }
           | funcaoTrig                                        { $$.valor = $1.valor }
           | funcaoProb                                        { $$.valor = $1.valor }
           | funcaoStrc                                        { $$.valor = $1.valor }
           | funcaoUSer                                        { $$.valor = $1.valor }
           ;
*/

/*funcao     : funcaoArit                                        { $$.valor = $1.valor }
           | funcaoTrig                                        { $$.valor = $1.valor }
           | funcaoStrc                                        { $$.valor = $1.valor }
           | funcaoUSer                                        { $$.valor = $1.valor }
           ;
*/


funcao     : funcaoArit                                        { $$.valor = $1.valor; }
           | funcaoTrig                                        { $$.valor = $1.valor; }
           ;




numero     : NUMD                                              { $$.valor = $1.valor;                                               fprintf(stdout, "Decimal:%g", $1.valor);}
           | NUMB                                              { $$.valor = $1.valor;                                               fprintf(stdout, "Binario:%g", $1.valor);}
           | NUMH                                              { $$.valor = $1.valor;                                               fprintf(stdout, "Hexa:%g", $1.valor);}
           ;

/*atributo   : ATRIB                                             { $$.valor = $1.valor; }
           ;

*/

/*atribuicao : atributo '=' expressao                            { $$.valor = $3.valor; }
           | variavel '=' expressao                            { $$.valor = $3.valor; }
						;
*/

/*variavel   : VARI '[' expressao ','
    			             expressao ']'                            { auxVari := Genesys.Model.SIMAN.Variable[trunc($1.valor)];
                                                                 if (auxVari.Dimension1 > 1) and (auxVari.Dimension2 > 1) then begin
                                                                      if (trunc($3.valor) > 0) and (trunc($3.valor) <= auxVari.Dimension1) and (trunc($5.valor) > 0) and (trunc($5.valor) <= auxVari.Dimension2) then
                                                                           $$.valor := Genesys.Model.SIMAN.Variablevalue[trunc($1.valor), trunc($3.valor), trunc($5.valor)]
                                                                      else yyoutput.Add('Index out of range');
                                                                      end
                                                                 else begin
                                                                      $$.valor := 0;
                                                                      yyoutput.Add('Error: Variable with wrong dimensions'); end;}
						| VARI '[' expressao ']'                            { auxVari := Genesys.Model.SIMAN.Variable[trunc($1.valor)];
                                                                 if (auxVari.Dimension1 = 1) and (auxVari.Dimension2 > 1) then begin
																																	     if (trunc($3.valor) > 0) and (trunc($3.valor) <= auxVari.Dimension2) then
                                                                           $$.valor := Genesys.Model.SIMAN.Variablevalue[trunc($1.valor), 1, trunc($3.valor)]
																																			 else yyoutput.Add('Index out of range');
																																			 end
                                                                 else begin
                                                                      $$.valor := 0;
                                                                      yyoutput.Add('Error: Variable with wrong dimensions'); end;}
           | VARI                                              { auxVari := Genesys.Model.SIMAN.Variable[trunc($1.valor)];
																																	if (auxVari.Dimension1 = 1) and (auxVari.Dimension2 = 1) then
																																	     $$.valor := Genesys.Model.SIMAN.Variablevalue[trunc($1.valor),1,1]
																																	else begin
                                                                      $$.valor := 0;
																																			 yyoutput.Add('Erro:Variavel sem indices'); end;}
						;

formula    : FORM '[' expressao ','
                      expressao ']'                            { auxForm := Genesys.Model.SIMAN.Formula[trunc($1.valor)];
                                                                 if (auxForm.Dimension1 > 1) and (auxForm.Dimension2 > 1) then begin
                                                                      if (trunc($3.valor) > 0) and (trunc($3.valor) <= auxForm.Dimension1) and (trunc($5.valor) > 0) and (trunc($5.valor) <= auxForm.Dimension2) then
                                                                           $$.valor := Genesys.Model.SIMAN.FormulaValue[trunc($1.valor), trunc($3.valor), trunc($5.valor)]
                                                                      else yyoutput.Add('Index out of range');
                                                                      end
                                                                 else begin
                                                                      $$.valor := 0;
                                                                      yyoutput.Add('Error: Formula with wrong dimensions'); end;}
           | FORM '[' expressao ']'                            { auxForm := Genesys.Model.SIMAN.Formula[trunc($1.valor)];
                                                                 if (auxForm.Dimension1 = 1) and (auxForm.Dimension2 > 1) then begin
                                                                      if (trunc($3.valor) > 0) and (trunc($3.valor) <= auxForm.Dimension2) then
                                                                           $$.valor := Genesys.Model.SIMAN.FormulaValue[trunc($1.valor), 1, trunc($3.valor)]
                                                                      else yyoutput.Add('Index out of range');
                                                                      end
                                                                 else begin
                                                                      $$.valor := 0;
                                                                      yyoutput.Add('Error: Formula with wrong dimensions'); end;}
           | FORM                                              { auxForm := Genesys.Model.SIMAN.Formula[trunc($1.valor)];
                                                                 if (auxForm.Dimension1 = 1) and (auxForm.Dimension2 = 1) then
                                                                      $$.valor := Genesys.Model.SIMAN.FormulaValue[trunc($1.valor),1,1]
                                                                 else begin
                                                                      $$.valor := 0;
                                                                      yyoutput.Add('Error: Formula with wrong dimensions'); end;}
           ;
*/

funcaoTrig : fSIN   '(' expressao ')'                          { $$.valor = sin($3.valor);                                         fprintf(stdout, "Sin(%g)", $3.valor);}
           | fCOS   '(' expressao ')'                          { $$.valor = cos($3.valor); 																				fprintf(stdout, "Cos(%g)", $3.valor);}
           ;

funcaoArit : fAINT  '(' expressao ')'                          { $$.valor = (int) $3.valor;}
           | fFRAC  '(' expressao ')'                          { $$.valor = $3.valor - (int) $3.valor;}
						| fINT   '(' expressao ')'                         { $$.valor = (int) $3.valor;}
           | fMOD   '(' expressao ','
                        expressao ')'                          { $$.valor = (int) $3.valor % (int) $5.valor; }
           ;

/*funcaoProb : fEXPO  '(' expressao ')'                          { $$.valor := Genesys.Model.SIMAN.SampleExponential($3.valor) }
           | fNORM  '(' expressao ','
                        expressao ')'                          { $$.valor := Genesys.Model.SIMAN.SampleNormal($3.valor,$5.valor) }
           | fUNIF  '(' expressao ','
                        expressao ')'                          { $$.valor := Genesys.Model.SIMAN.SampleUniform($3.valor,$5.valor) }
           | fWEIB  '(' expressao ','
                        expressao ')'                          { $$.valor := Genesys.Model.SIMAN.SampleWeibull($3.valor,$5.valor) }
           | fLOGN  '(' expressao ','
                        expressao ')'                          { $$.valor := Genesys.Model.SIMAN.SampleLognormal($3.valor,$5.valor) }
           | fGAMM  '(' expressao ','
                        expressao ')'                          { $$.valor := Genesys.Model.SIMAN.SampleGamma($3.valor,$5.valor) }
           | fERLA  '(' expressao ','
                        expressao ')'                          { $$.valor := Genesys.Model.SIMAN.SampleErlang($3.valor,trunc($5.valor)) }
           | fTRIA  '(' expressao ','
                        expressao ','
                        expressao ')'                          { $$.valor := Genesys.Model.SIMAN.SampleTriangular($3.valor,$5.valor,$7.valor) }
           | fBETA  '(' expressao ','
                        expressao ','
                        expressao ','
                        expressao ')'                          { $$.valor := Genesys.Model.SIMAN.SampleBeta($3.valor,$5.valor,$7.valor,$9.valor) }
           | fDISC  '(' listaparm ')'
           ;

funcaoStrc : fNQ       '(' QUEUE ')'                           { $$.valor := Genesys.Model.SIMAN.Queue[trunc($3.valor)].Waiting.Count;}
           | fLASTINQ  '(' QUEUE ')'                           { auxword := Genesys.Model.SIMAN.Queue[trunc($3.valor)].Waiting.Count;
																																	if auxword > 0 then
                                                                      $$.valor := TWaiting(Genesys.Model.SIMAN.Queue[trunc($3.valor)].Waiting.Objects[auxword-1]).EntityID
                                                                 else $$.valor := 0;}
           | fFIRSTINQ '(' QUEUE ')'                           { if Genesys.Model.SIMAN.Queue[trunc($3.valor)].Waiting.Count > 0 then
                                                                      $$.valor := TWaiting(Genesys.Model.SIMAN.Queue[trunc($3.valor)].Waiting.Objects[0]).EntityID
                                                                 else $$.valor := 0;}
           | fMR        '(' RES ')'                            { $$.valor := Genesys.Model.SIMAN.Resource[trunc($3.valor)].Capacity; }
           | fNR        '(' RES ')'                            { $$.valor := Genesys.Model.SIMAN.Resource[trunc($3.valor)].NumberBusy; }
           | fRESSEIZES '(' RES ')'                            { $$.valor := Genesys.Model.SIMAN.Resource[trunc($3.valor)].Seizes; }
           | fSTATE     '(' RES ')'                            { case Genesys.Model.SIMAN.Resource[trunc($3.valor)].State of
                                                                      rsIDLE:     $$.valor := -1;
                                                                      rsBUSY:     $$.valor := -2;
                                                                      rsFAILED:   $$.valor := -4;
                                                                      rsINACTIVE: $$.valor := -3;
                                                                 else $$.valor := -5; end;}

           | fIRF       '(' RES ')'                            { if Genesys.Model.SIMAN.Resource[trunc($3.valor)].State = rsFAILED then $$.valor := 1 else $$.valor := 0;}
           | fTNOW                                             { $$.valor := Genesys.Model.TNOW;}
           | fTFIN                                             { $$.valor := Genesys.Model.ReplicationLenght;}
           ;

funcaoUser : 'USER' '(' expressao ')'                          { $$.valor := $3.valor }
           ;

listaparm  : listaparm ',' expressao ',' expressao
           | expressao ',' expressao
           ;
*/


%%
void
yy::genesyspp_parser::error (const location_type& l,
                          const std::string& m)
{
  driver.error (l, m);
}
