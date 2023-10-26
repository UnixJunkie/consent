CFLAGS := `pkg-config --silence-errors --cflags openbabel-2.0 || pkg-config --cflags openbabel-3`
LDFLAGS := `pkg-config --silence-errors --libs openbabel-2.0 || pkg-config --libs openbabel-3`

ob_maccs: ob_maccs.cpp
	c++ -W -Wall $(CFLAGS) ob_maccs.cpp \
	  -o lbvs_consent_ob_maccs $(LDFLAGS) -Wl,-R/usr/lib

clean:
	\rm -f lbvs_consent_ob_maccs
