#include "obj_t.hh"
#include <string>

obj_t::obj_t(){

}

obj_t::~obj_t(){
  
}

obj_t::obj_t(double v, std::string t){
  valor = v;
  tipo = t;
}
