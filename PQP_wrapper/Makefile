CPPFLAGS = -O2 -fPIC
INCLUDE =   -I../../../software/PQP_v1.3/include
LIBRARIES = ../../../software/PQP_v1.3/lib/libPQP.a
EXTENSION = mexglx


all: pqp_createmodel.$(EXTENSION) pqp_deletemodel.$(EXTENSION) pqp_intersect.$(EXTENSION) pqp_distance.$(EXTENSION)

%.mexglx : %.cc
	mex $< $(INCLUDE) $(LIBRARIES)
	cp $@ ../..

%.mexa64 : %.cc
	mex $< $(INCLUDE) $(LIBRARIES)
	cp $@ ../..

clean:
	rm -f *.mexglx *.mexa64