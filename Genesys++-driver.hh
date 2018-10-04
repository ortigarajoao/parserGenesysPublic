#ifndef GENESYSPP_DRIVER_HH
# define GENESYSPP_DRIVER_HH
# include <string>
# include <map>
# include "Genesys++-parser.hh"
// Tell Flex the lexer's prototype ...


# define YY_DECL \
  yy::genesyspp_parser::symbol_type yylex (genesyspp_driver& driver)

// # define YY_DECL \
//   yy::genesyspp_parser::symbol_type yylex (semantic_type* yylval, location_type* yylloc, genesyspp_driver& driver)
// ... and declare it for the parser's sake.
YY_DECL;
// Conducting the whole scanning and parsing of Calc++.
class genesyspp_driver
{
public:
  genesyspp_driver ();
  virtual ~genesyspp_driver ();

  //std::map<std::string, int> variables; not needed

  int result;
  // Handling the scanner.
  void scan_begin ();
  void scan_begin_file ();
  void scan_end_file ();
  void scan_begin_str ();
  void scan_end_str ();

  bool trace_scanning;
  // Run the parser on file F.
  // Return 0 on success.
  int parse_file (const std::string& f);
  int parse_str (const std::string& str);
  // The name of the file being parsed.
  // Used later to pass the file name to the location tracker.
  std::string file;
  std::string str_to_parse;
  // Whether parser traces should be generated.
  bool trace_parsing;
  // Error handling.
  void error (const yy::location& l, const std::string& m);
  void error (const std::string& m);
};
#endif // ! GENESYSPP_DRIVER_HH
