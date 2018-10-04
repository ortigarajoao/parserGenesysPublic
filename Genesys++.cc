#include <iostream>
#include "Genesys++-driver.hh"


int
main (int argc, char *argv[])
{
  int res = 0;
  genesyspp_driver driver;
  std::cout << "Entrada:" << '\n';
  for (std::string line; std::getline(std::cin, line);) {
        res = driver.parse_str(line);
  }



  /*int res = 0;
  calcxx_driver driver;
  for (int i = 1; i < argc; ++i)
    if (argv[i] == std::string ("-p"))
      driver.trace_parsing = true;
    else if (argv[i] == std::string ("-s"))
      driver.trace_scanning = true;
    else if (!driver.parse (argv[i]))
      std::cout << driver.result << '\n';
    else
      res = 1;
  return res;
  */
  std::cout << "/* Foi porra */" << '\n';
  return 0;
}
