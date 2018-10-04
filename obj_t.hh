#ifndef OBJ_T_HH
#define OBJ_T_HH
#include <string>

class obj_t {
public:
  obj_t();
  virtual ~obj_t();
  obj_t(double v, std::string t);
  double valor;
  std::string tipo;
};

#endif
