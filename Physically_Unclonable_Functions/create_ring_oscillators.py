from numpy.random import normal

def create_ring_oscillator(fname, idx, pl, pw, nl, nw, po, no):
    file = open(fname, 'w')

    file.write("* ring_oscillator_"+str(idx) + "\n")
    file.write("\n.include nand.cir")
    file.write("\n.include inverter.cir\n")
    file.write("\n.subckt ring_oscillator_"+str(idx) + " in out vdd vss")
    file.write("\nx0 in out s1 vdd vss nand")
    pl_vals = (normal(pl, pl*0.065, (12,)))
    pw_vals = (normal(pw, pw*0.065, (12,)))
    nl_vals = (normal(nl, nl*0.065, (12,)))
    nw_vals = (normal(nw, nw*0.065, (12,)))
    po_vals = (normal(po, po*0.05, (12,)))
    no_vals = (normal(no, no*0.05, (12,)))
    for i in range(1, 12):
        file.write("\nx"+str(i)+" s"+str(i) + " s"+str(i+1) + " vdd vss inverter tplv=%s tpwv=%s tnln=%s tnwn=%s tpotv=%s tnotv=%s inverter" %(pl_vals[i-1], pw_vals[i-1], nl_vals[i-1], nw_vals[i-1], po_vals[i-1], no_vals[i-1]))
    file.write("\nx12 s12 out" + " vdd vss inverter tplv=%s tpwv=%s tnln=%s tnwn=%s tpotv=%s tnotv=%s inverter" %(pl_vals[-1], pw_vals[-1], nl_vals[-1], nw_vals[-1], po_vals[-1], no_vals[-1]))
    file.write("\n.ends ring_oscillator_"+str(idx))
    file.close

if __name__ == "__main__":
    num_circuits = 8

    pl = 65e-9
    pw = 215e-9
    nl = 65e-9
    nw = 130e-9
    po = 1.95e-9
    no = 1.85e-9

    for i in range(num_circuits):
        fname = "ring_oscillator_"+str(i)+".cir"
        create_ring_oscillator(fname, i, pl, pw, nl, nw, po, no)
