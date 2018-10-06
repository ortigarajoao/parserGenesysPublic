%{ /* -*- C++ -*- */
# include <cerrno>
# include <climits>
# include <cstdlib>
# include <string>
# include "Genesys++-driver.hh"
# include "Genesys++-parser.hh"
# include "obj_t.hh"

// Work around an incompatibility in flex (at least versions
// 2.5.31 through 2.5.33): it generates code that does
// not conform to C89.  See Debian bug 333231
// <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=333231>.
# undef yywrap
# define yywrap() 1

// The location of the current token.
static yy::location loc;
%}
%option noyywrap nounput batch noinput

%{
  // Code run each time a pattern is matched.
  # define YY_USER_ACTION  loc.columns (yyleng);
%}

I     ~[A-Za-z]+
DD     [-]?[0-9]+([eE][-]?[0-9]+)?
RR     [-]?[0-9]+[.][0-9]+([eE][-]?[0-9]+)?
L      [A-Za-z0-9_.]+

%%

%{
  // Code run each time yylex is called.
  loc.step ();
%}

[0][bB][0-1]+   {
					//Binary number
					//yylval.valor = atof(yytext); //If class, change to setter, if struct OK
												//Check if 0.0(error return) is problematic
					return yy::genesyspp_parser::make_NUMB(obj_t(atof(yytext), std::string("Binario")),loc);
				}

[0][xX][aA-fF0-9]+  {
						//Hexadecimal number
						//yylval.valor = atof(yytext); //If class, change to setter, if struct OK
													//Check if 0.0(error return) is problematic
						return yy::genesyspp_parser::make_NUMH(obj_t(atof(yytext), std::string("Hexadecimal")),loc);
					}

{RR}  {
       //Float number
       obj_t o(atof(yytext),std::string("Float"));
       return yy::genesyspp_parser::make_NUMD(o, loc);
  		 //Maybe needs to change dot to comma
  		 if(o.valor > 0.0){
        return yy::genesyspp_parser::make_NUMD(o, loc);
  		 } else {
         std::cout << "Nao é maior que 0.0" << '\n';
  			return yy::genesyspp_parser::make_ILLEGAL(obj_t(0, std::string("Ilegal")), loc); //maybe call driver.error or throw exception
  		 }
     }

{DD}  {
       //Decimal number
       obj_t o(atof(yytext),std::string("Decimal"));
       return yy::genesyspp_parser::make_NUMD(o, loc);
  		 if(o.valor > 0.0){
  			return yy::genesyspp_parser::make_NUMD(o, loc);
  		 } else {
         std::cout << "Nao é maior que 0.0 Decimal" << '\n';
  			return yy::genesyspp_parser::make_ILLEGAL(obj_t(0, std::string("Ilegal")), loc); //maybe call driver.error or throw exception
  		 }
      }

[<][=]   { return (yy::genesyspp_parser::make_oLE(obj_t(), loc));}
[>][=]   { return (yy::genesyspp_parser::make_oGE(obj_t(), loc));}
[=][=]   { return (yy::genesyspp_parser::make_oEQ(obj_t(), loc));}
[<][>]   { return (yy::genesyspp_parser::make_oNE(obj_t(), loc));}

[tT][rR][uU][eE]      {return yy::genesyspp_parser::make_NUMD(obj_t(1, std::string("Booleano")), loc);}
[fF][aA][lL][sS][eE]  {return yy::genesyspp_parser::make_NUMD(obj_t(0, std::string("Booleano")), loc);}

[iI][fF]              {return yy::genesyspp_parser::make_cIF(obj_t(0, std::string(yytext)), loc);}
[eE][lL][sS][eE]      {return yy::genesyspp_parser::make_cELSE(obj_t(0, std::string(yytext)), loc);}
[fF][oO][rR]          {return yy::genesyspp_parser::make_cFOR(obj_t(0, std::string(yytext)), loc);}
[tT][oO]              {return yy::genesyspp_parser::make_cTO(obj_t(0, std::string(yytext)), loc);}
[dD][oO]              {return yy::genesyspp_parser::make_cDO(obj_t(0, std::string(yytext)), loc);}

[aA][nN][dD]    {return yy::genesyspp_parser::make_oAND(obj_t(0, std::string(yytext)), loc);}
[oO][rR]        {return yy::genesyspp_parser::make_oOR(obj_t(0, std::string(yytext)), loc);}
[nN][oO][tT]    {return yy::genesyspp_parser::make_oNOT(obj_t(0, std::string(yytext)), loc);}

[sS][iI][nN]      {return yy::genesyspp_parser::make_fSIN(obj_t(0, std::string(yytext)), loc);}
[cC][oO][sS]      {return yy::genesyspp_parser::make_fCOS(obj_t(0, std::string(yytext)), loc);}

[aA][iI][nN][tT]  {return yy::genesyspp_parser::make_fAINT(obj_t(0, std::string(yytext)), loc);}
[fF][rR][aA][cC]  {return yy::genesyspp_parser::make_fFRAC(obj_t(0, std::string(yytext)), loc);}
[mM][oO][dD]      {return yy::genesyspp_parser::make_fMOD(obj_t(0, std::string(yytext)), loc);}
[iI][nN][tT]      {return yy::genesyspp_parser::make_fINT(obj_t(0, std::string(yytext)), loc);}

[eE][xX][pP][oO]  {return yy::genesyspp_parser::make_fEXPO(obj_t(0, std::string(yytext)), loc);}
[nN][oO][rR][mM]  {return yy::genesyspp_parser::make_fNORM(obj_t(0, std::string(yytext)), loc);}
[uU][nN][iI][fF]  {return yy::genesyspp_parser::make_fUNIF(obj_t(0, std::string(yytext)), loc);}
[wW][eE][iI][bB]  {return yy::genesyspp_parser::make_fWEIB(obj_t(0, std::string(yytext)), loc);}
[lL][oO][gG][nN]  {return yy::genesyspp_parser::make_fLOGN(obj_t(0, std::string(yytext)), loc);}
[gG][aA][mM][mM]  {return yy::genesyspp_parser::make_fGAMM(obj_t(0, std::string(yytext)), loc);}
[eE][rR][lL][aA]  {return yy::genesyspp_parser::make_fERLA(obj_t(0, std::string(yytext)), loc);}
[tT][rR][iI][aA]  {return yy::genesyspp_parser::make_fTRIA(obj_t(0, std::string(yytext)), loc);}
[bB][eE][tT][aA]  {return yy::genesyspp_parser::make_fBETA(obj_t(0, std::string(yytext)), loc);}
[dD][iI][sS][cC]  {return yy::genesyspp_parser::make_fDISC(obj_t(0, std::string(yytext)), loc);}

[tT][nN][oO][wW]  {return yy::genesyspp_parser::make_fTNOW(obj_t(0, std::string(yytext)), loc);}
[tT][fF][iI][nN]  {return yy::genesyspp_parser::make_fTFIN(obj_t(0, std::string(yytext)), loc);}

[nN][rR]                             {return yy::genesyspp_parser::make_fNR(obj_t(0, std::string(yytext)), loc);}
[mM][rR]                             {return yy::genesyspp_parser::make_fMR(obj_t(0, std::string(yytext)), loc);}
[iI][rR][fF]                         {return yy::genesyspp_parser::make_fIRF(obj_t(0, std::string(yytext)), loc);}
[sS][tT][aA][tT][eE]                 {return yy::genesyspp_parser::make_fSTATE(obj_t(0, std::string(yytext)), loc);}
[rR][eE][sS][sS][eE][iI][zZ][eE][sS] {return yy::genesyspp_parser::make_fRESSEIZES(obj_t(0, std::string(yytext)), loc);}

[iI][dD][lL][eE][_][rR][eE][sS]                 {return yy::genesyspp_parser::make_NUMD(obj_t(-1, std::string(yytext)), loc);}
[bB][uU][sS][yY][_][rR][eE][sS]                 {return yy::genesyspp_parser::make_NUMD(obj_t(-2, std::string(yytext)), loc);}
[iI][nN][aA][cC][tT][iI][vV][eE][_][rR][eE][sS] {return yy::genesyspp_parser::make_NUMD(obj_t(-3, std::string(yytext)), loc);}
[fF][aA][iI][lL][eE][dD][_][rR][eE][sS]         {return yy::genesyspp_parser::make_NUMD(obj_t(-4, std::string(yytext)), loc);}

[nN][qQ]                             {return yy::genesyspp_parser::make_fNQ(obj_t(0, std::string(yytext)), loc);}
[lL][aA][sS][tT][iI][nN][qQ]         {return yy::genesyspp_parser::make_fLASTINQ(obj_t(0, std::string(yytext)), loc);}
[fF][iI][rR][sS][tT][iI][nN][qQ]     {return yy::genesyspp_parser::make_fFIRSTINQ(obj_t(0, std::string(yytext)), loc);}

[tT][eE][sS][tT][eE] {return yy::genesyspp_parser::make_TESTE(obj_t(0, std::string(yytext)), loc);}

[(] {return yy::genesyspp_parser::make_LPAREN(loc);}
[)] {return yy::genesyspp_parser::make_RPAREN(loc);}

[+] {return yy::genesyspp_parser::make_PLUS(loc);}
[-] {return yy::genesyspp_parser::make_MINUS(loc);}
[*] {return yy::genesyspp_parser::make_STAR(loc);}
[/] {return yy::genesyspp_parser::make_SLASH(loc);}

[<] {return yy::genesyspp_parser::make_LESS(loc);}
[>] {return yy::genesyspp_parser::make_GREATER(loc);}

[=] {return yy::genesyspp_parser::make_ASSIGN(loc);}

[,] {return yy::genesyspp_parser::make_COMMA(loc);}

[ \t\n]        ;

.       {return yy::genesyspp_parser::make_ILLEGAL(obj_t(0, std::string("Ilegal")), loc);}

<<EOF>> {return yy::genesyspp_parser::make_END(loc);}


%%

void
genesyspp_driver::scan_begin_file ()
{
  yy_flex_debug = trace_scanning;
  if (file.empty () || file == "-")
    yyin = stdin;
  else if (!(yyin = fopen (file.c_str (), "r")))
    {
      error ("cannot open " + file + ": " + strerror(errno));
      exit (EXIT_FAILURE);
    }
}

void genesyspp_driver::scan_begin_str ()
{
  yy_flex_debug = trace_scanning;
  if(!str_to_parse.empty()){
    yy_scan_string (str_to_parse.c_str()); //maybe throw exception on else
  }
}



void
genesyspp_driver::scan_end_file ()
{
  fclose (yyin);
}

void
genesyspp_driver::scan_end_str ()
{
  yy_delete_buffer(YY_CURRENT_BUFFER);
}
