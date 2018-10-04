all: Genesys++.out

Genesys++.out: Genesys++-driver.o Genesys++-parser.o Genesys++-scanner.o Genesys++.o obj_t.o

	g++ -o Genesys++.out Genesys++-driver.o Genesys++-parser.o Genesys++-scanner.o Genesys++.o obj_t.o

Genesys++-driver.o: Genesys++-driver.cc Genesys++-driver.hh Genesys++-parser.hh obj_t.hh

	g++ -c Genesys++-driver.cc

Genesys++-parser.o: Genesys++-parser.cc Genesys++-parser.hh Genesys++-driver.hh obj_t.hh

	g++ -c Genesys++-parser.cc

Genesys++-parser.cc Genesys++-parser.hh: Genesys++-parser.yy

	bison --defines=Genesys++-parser.hh -o Genesys++-parser.cc Genesys++-parser.yy

Genesys++-scanner.o: Genesys++-scanner.cc Genesys++-parser.hh Genesys++-driver.hh obj_t.hh

	g++ -c Genesys++-scanner.cc

Genesys++-scanner.cc: Genesys++-scanner.ll

	flex -o Genesys++-scanner.cc Genesys++-scanner.ll

Genesys++.o: Genesys++.cc

	g++ -c Genesys++.cc

obj_t.o: obj_t.cc obj_t.hh
	g++ -c obj_t.cc

.PHONY: clean

clean:

	-rm *.o Genesys++-parser.hh Genesys++-parser.cc Genesys++-scanner.cc location.hh position.hh stack.hh Genesys++.out err.log
