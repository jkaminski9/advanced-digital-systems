for f in ring_oscillator ro_puf counter project_pkg toplevel; do \
    ghdl analyze ../${f}.vhd; \
done
cd ..
