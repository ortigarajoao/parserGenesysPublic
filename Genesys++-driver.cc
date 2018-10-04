#include "Genesys++-driver.hh"
#include "Genesys++-parser.hh"

genesyspp_driver::genesyspp_driver ()
  : trace_scanning (false), trace_parsing (false)
{
  //variables["one"] = 1;
  //variables["two"] = 2;
}

genesyspp_driver::~genesyspp_driver ()
{
}

int
genesyspp_driver::parse_file (const std::string &f)
{
  file = f;
  scan_begin_file();
  yy::genesyspp_parser parser (*this);
  parser.set_debug_level(trace_parsing);
  int res = parser.parse();
  scan_end_file();
  return res;
}

int
genesyspp_driver::parse_str (const std::string &str)
{
  str_to_parse = str;
  scan_begin_str();
  yy::genesyspp_parser parser(*this);
  parser.set_debug_level(trace_parsing);
  int res = parser.parse();
  scan_end_str();
  return res;
}


void
genesyspp_driver::error (const yy::location& l, const std::string& m)
{
  std::cerr << l << ": " << m << '\n';
}

void
genesyspp_driver::error (const std::string& m)
{
  std::cerr << m << '\n';
}
